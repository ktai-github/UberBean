//
//  ViewController.m
//  UberBean
//
//  Created by KevinT on 2018-03-02.
//  Copyright © 2018 KevinT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *cLLocationManager;
@property (nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) NSMutableArray *cafeMutArray;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

//  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  self.mapView.backgroundColor = [UIColor blueColor];
  [self.view addSubview:self.mapView];

  self.cLLocationManager = [[CLLocationManager alloc] init];
  [self.cLLocationManager requestWhenInUseAuthorization];
  self.cLLocationManager.delegate = self;

  self.mapView.showsUserLocation = YES;

  self.cafeMutArray = [[NSMutableArray alloc] init];
  
//  NSString *urlString = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=3c526ed9d9e101c1083db43c436943d7&tags=cat";
  NSString *urlString = @"https://api.yelp.com/v3/businesses/search?term=cafe&latitude=49.281815&longitude=-123.108414";
  NSURL *url = [NSURL URLWithString:urlString];
  
  NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    if (error != nil) {
      return;
    }
    
    //    dispatch_async(dispatch_get_main_queue(), <#^(void)block#>)
//    [self parseResponseData:data];
  }];
  [dataTask resume];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    [self.cLLocationManager requestLocation];
    NSLog(@"location requested");
  }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  CLLocation *vancouverLocation = locations[0];

  MKCoordinateRegion mkCoordinateRegion = MKCoordinateRegionMake(vancouverLocation.coordinate, MKCoordinateSpanMake(.06/111.0, .06/111.0));
  [self.mapView setRegion:mkCoordinateRegion animated:TRUE];
//  self.mapView.region = mkCoordinateRegion;
  NSLog(@"zoomed in on location");
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Error: %@", error);
}


@end
