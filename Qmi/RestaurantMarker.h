//
//  RestaurantMarker.h
//  Qmi
//
//  Created by Dan Christal on 2016-10-05.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "Restaurant.h"

@interface RestaurantMarker : GMSMarker

@property (nonatomic) Restaurant *restaurant;

@end
