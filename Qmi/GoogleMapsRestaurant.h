//
//  Restaurant.h
//  Qmi
//
//  Created by Philip Ha on 2016-10-04.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface GoogleMapsRestaurant : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * address;

- (instancetype)initWithName:(NSString *)name address:(NSString *)address andCoordinate:(CLLocationCoordinate2D)coordinate;

@end
