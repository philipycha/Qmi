//
//  LocationManager.h
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
@import UIKit;

@interface LocationManager : NSObject

@property (nonatomic) CLLocationManager * locationManager;
@property (nonatomic) CLLocation * currentLocation;


-(void)setupLocationManager;
+(LocationManager *) sharedLocationManager;

@end
