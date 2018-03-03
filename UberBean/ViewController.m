////
////  ViewController.m
////  UberBean
////
////  Created by KevinT on 2018-03-02.
////  Copyright © 2018 KevinT. All rights reserved.
////
//
//#import "ViewController.h"
//
//@interface ViewController () <CLLocationManagerDelegate>
//
//@property (nonatomic) CLLocationManager *cLLocationManager;
//@property (nonatomic) MKMapView *mapView;
//
//@end
//
//@implementation ViewController
//
//- (void)viewDidLoad {
//  [super viewDidLoad];
//  // Do any additional setup after loading the view, typically from a nib.
//
//  self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//  self.mapView.backgroundColor = [UIColor blueColor];
//  [self.view addSubview:self.mapView];
//
//  self.cLLocationManager = [[CLLocationManager alloc] init];
//  [self.cLLocationManager requestWhenInUseAuthorization];
//  self.cLLocationManager.delegate = self;
//
//  self.mapView.showsUserLocation = YES;
////  [self.cLLocationManager requestLocation];
//
//  }
//
//
//- (void)didReceiveMemoryWarning {
//  [super didReceiveMemoryWarning];
//  // Dispose of any resources that can be recreated.
//}
//
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//   NSLog(@"location authorization status: %i", status);
//  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
//    [self.cLLocationManager requestLocation];
//  }
//}
//
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//  CLLocation *vancouverLocation = locations[0];
////  CLLocationCoordinate2D *vancouverLocation2 = [CLLocationCoordinate2DMake(<#CLLocationDegrees latitude#>, <#CLLocationDegrees longitude#>)];
////  (49.2827 , -123.1207)
//  MKCoordinateRegion mkCoordinateRegion = MKCoordinateRegionMake(vancouverLocation.coordinate, MKCoordinateSpanMake(1.0/111/0, 1.0/111.0));
//
//  self.mapView.region = mkCoordinateRegion;
//}
//
//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//  NSLog(@"Error: %@", error);
//}
//@end





#import "ViewController.h"
@import CoreLocation;
@import MapKit;
@import UIKit;

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property ( nonatomic) MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mapView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.mapView];
  
  self.manager = [[CLLocationManager alloc] init];
  [self.manager requestWhenInUseAuthorization];
  self.manager.delegate = self;
  
  self.mapView.showsUserLocation = YES;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  NSLog(@"location authorization status: %i", status);
  
  if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
    // We're good to go
    [self.manager requestLocation];
  }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  CLLocation *myLocation = locations[0];
  NSLog(@"%@", myLocation);
  
  MKCoordinateRegion region = MKCoordinateRegionMake(myLocation.coordinate, MKCoordinateSpanMake(1.0/111.0, 1.0/111.0));
  
  self.mapView.region = region;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  NSLog(@"Error: %@", error);
}

@end
