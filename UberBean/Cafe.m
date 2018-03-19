//
//  Cafe.m
//  UberBean
//
//  Created by KevinT on 2018-03-04.
//  Copyright © 2018 KevinT. All rights reserved.
//

#import "Cafe.h"

@implementation Cafe

- (instancetype)initWithJSON:(NSDictionary *)json {
  if (self = [super init]) {
    _title = json[@"name"];
    _imageURL = json[@"image-url"];
    _rating = json[@"rating"];
    NSNumber *lat = json[@"coordinates"][@"latitude"];
    NSNumber *lng = json[@"coordinates"][@"longitude"];
    _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
  }
  return self;
}

//- (instancetype)initWithDict: (NSDictionary *) cafeDict
//{
//  self = [super init];
//  if (self) {
//    NSString *cafeName = cafeDict[@"name"];
//    NSString *imageUrlString = cafeDict[@"image_url"];
//    NSDictionary *coordDict = cafeDict[@"coordinates"];
//    double locX = [coordDict[@"longitude"] doubleValue];
//    double locY = [coordDict[@"latitude"] doubleValue];
//
//    _cafeName = cafeName;
//    _imageURL = [NSURL URLWithString:imageUrlString];
//    _locX = locX;
//    _locY = locY;
//    NSNumber *farmID = photo[@"farm"];
//    NSNumber *secret = photo[@"secret"];
//    NSNumber *photoID = photo[@"id"];
//    NSString *server = photo[@"server"];
//    NSString *title = photo[@"title"];
//
//    NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmID, server, photoID, secret];
//    NSLog(@"%@", urlString);
//    NSLog(@"%@", title);
//
//    _url = [NSURL URLWithString:urlString];
//    _title = title;
//  }
//  return self;
//}

@end
