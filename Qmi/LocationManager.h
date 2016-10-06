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

@protocol locationManagerDelegate <NSObject>

-(void)updateCamera;
-(void)getRestaurantLocation;

@end

@interface LocationManager : NSObject

@property (nonatomic) CLLocationManager * locationManager;
@property (nonatomic) CLLocation * currentLocation;
@property (nonatomic) id <locationManagerDelegate> delegate;
- (void)startLocationMonitoring;
-(void)setupLocationManager;
+(LocationManager *) sharedLocationManager;

@end
