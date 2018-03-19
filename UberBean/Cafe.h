//
//  Cafe.h
//  UberBean
//
//  Created by KevinT on 2018-03-04.
//  Copyright © 2018 KevinT. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import MapKit;

@interface Cafe : NSObject<MKAnnotation>

- (instancetype) initWithJSON:(NSDictionary *)json;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSString *imageURL;
@property (nonatomic) NSString *rating;
@property (nonatomic) CLLocationCoordinate2D coordinate;
//@property (nonatomic) NSString *cafeName;
//@property (nonatomic) double locX;
//@property (nonatomic) double locY;

//- (instancetype) initWithDict: (NSDictionary *) cafeDict;

@end
