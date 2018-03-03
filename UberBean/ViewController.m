//
//  ViewController.m
//  UberBean
//
//  Created by KevinT on 2018-03-02.
//  Copyright © 2018 KevinT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  mapView.backgroundColor = [UIColor blueColor];
  [self.view addSubview:mapView];
  
  self.cLLocationManager = [[CLLocationManager alloc] init];
  [self.cLLocationManager requestWhenInUseAuthorization];
  self.cLLocationManager.delegate = self;
  
  mapView.showsUserLocation = TRUE;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
