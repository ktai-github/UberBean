//
//  ViewController.h
//  UberBean
//
//  Created by KevinT on 2018-03-02.
//  Copyright © 2018 KevinT. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;
@import MapKit;
@import UIKit;

@interface ViewController : UIViewController <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *cLLocationManager;
@property (nonatomic) MKMapView *mapView;

@end

