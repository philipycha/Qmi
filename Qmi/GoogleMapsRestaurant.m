//
//  Restaurant.m
//  Qmi
//
//  Created by Philip Ha on 2016-10-04.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "GoogleMapsRestaurant.h"

@implementation GoogleMapsRestaurant

- (instancetype)initWithName:(NSString *)name address:(NSString *)address rating:(NSString *) rating andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _name = name;
        _address = address;
        _rating = rating;
        _coordinate = coordinate;
    }
    return self;
}

@end
