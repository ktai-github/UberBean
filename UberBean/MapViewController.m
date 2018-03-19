//
//  MapViewController.m
//  UberBean
//
//  Created by KevinT on 2018-03-18.
//  Copyright © 2018 KevinT. All rights reserved.
//

#import "MapViewController.h"
#import "Cafe.h"
@import MapKit;
@import CoreLocation;

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@property (nonatomic) NSArray <MKAnnotation>*cafes;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  [self createMapView];
  self.locationManager = [[CLLocationManager alloc] init];
  self.locationManager.delegate = self;
  self.mapView.delegate = self;
  [self.mapView registerClass:[MKMarkerAnnotationView class] forAnnotationViewWithReuseIdentifier:@"Cafe"];
  //request authorization only runs if not determined, but
  [self.locationManager requestWhenInUseAuthorization];
}

#pragma mark - Create Map

- (void)createMapView {
  self.mapView = [[MKMapView alloc] init];
  self.mapView.showsUserLocation = YES;
  [self.view addSubview:self.mapView];
  
  self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.mapView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
  [self.mapView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
  [self.mapView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
  [self.mapView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking

- (void)fetchCafesWithUserLocation:(CLLocationCoordinate2D)location
                        searchTerm:(NSString*)searchTerm
                        completion:(void(^)(NSArray<MKAnnotation>*))handler {
  NSString *yelpAPIString = @"https://api.yelp.com/v3/businesses/search?term=cafe&latitude=49.281815&longitude=-123.108414";
  NSString *yelpAPIKey = @"BgYhenFNjU1zipLNEy3qHprMigciGVkuSxi7ZJKd0qVngwN5_YkPRuruN8RPR_puRBQrvG0bnBM84I4hRfQ488Ulw0e8Vv8Yd_YeIQ082BIZW_ngSeZ8x_ZPWcacWnYx";
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:yelpAPIString];
  NSURLQueryItem *categoryItem = [NSURLQueryItem queryItemWithName:@"categories" value:@"cafes"];
  NSURLQueryItem *searchItem = [NSURLQueryItem queryItemWithName:@"term" value:searchTerm];
  NSURLQueryItem *latItem = [NSURLQueryItem queryItemWithName:@"latitude" value:@(location.latitude).stringValue];
  NSURLQueryItem *lngItem = [NSURLQueryItem queryItemWithName:@"longitude" value:@(location.longitude).stringValue];
  urlComponents.queryItems = @[categoryItem, latItem, lngItem, searchItem];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlComponents.URL];
  request.HTTPMethod = @"GET";
  [request addValue:[NSString stringWithFormat:@"Bearer %@", yelpAPIKey] forHTTPHeaderField:@"Authorization"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (error) {
      NSLog(@"%@", error.localizedDescription);
      return;
    }
    
    NSUInteger statusCode = ((NSHTTPURLResponse*)response).statusCode;
    
    if (statusCode != 200) {
      NSLog(@"Error: status code is equal to %@", @(statusCode));
      return;
    }
    if (data == nil) {
      NSLog(@"Error: data is nil");
      return;
    }
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSArray<NSDictionary *>*jsonArray = json[@"businesses"];
    
    NSMutableArray *cafes = [NSMutableArray arrayWithCapacity:jsonArray.count];
    
    for (NSDictionary *item in jsonArray) {
      Cafe *cafe = [[Cafe alloc] initWithJSON:item];
      [cafes addObject:cafe];
      NSLog(@"%@", cafe.title);
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      handler([cafes copy]);
    }];
  }];
  [task resume];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  if (!self.currentLocation) {
    self.currentLocation = locations.firstObject;
    self.mapView.showsUserLocation = YES;
    [self setupRegion];
    
    [self fetchCafesWithUserLocation:self.currentLocation.coordinate searchTerm:nil completion:^(NSArray<MKAnnotation> *cafes) {
      self.cafes = cafes;
    }];
  }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
  MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Cafe" forAnnotation:annotation];
  if (annotationView == nil) {
    annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Cafe"];
  } else {
    annotationView.annotation = annotation;
  }
  
  annotationView.canShowCallout = YES;
  annotationView.animatesWhenAdded = YES;
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
  return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
}

static const double lat = 0.01;
static const double lng = 0.01;

- (void)setupRegion {
  MKCoordinateSpan span = MKCoordinateSpanMake(lat, lng);
  MKCoordinateRegion region = MKCoordinateRegionMake(self.currentLocation.coordinate, span);
  [self.mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"%@, %@", error.localizedDescription, error.localizedFailureReason);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  // called each time with the status
  NSLog(@"%@: %@", @(__LINE__), @(status)); // 0 is not determined
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [manager requestLocation];
  }
}

#pragma mark - Cafes Setter

- (void)setCafes:(NSArray<MKAnnotation> *)cafes {
  
  _cafes = cafes;
  [self.mapView addAnnotations:cafes];
  [self.mapView showAnnotations:cafes animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
}

#pragma mark - Shake

- (BOOL)becomeFirstResponder {
  return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (motion == UIEventSubtypeMotionShake) {
    NSLog(@"Present the search view controller");
  }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
