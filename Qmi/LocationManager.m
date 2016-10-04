//
//  LocationManager.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>


@end


@implementation LocationManager

+(LocationManager *) sharedLocationManager{
    static LocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[self alloc]init];
    });
    return sharedLocationManager;
}


- (void)startLocationMonitoring{
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ((!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setupLocationManager];
            
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location services are disabled, Please go into Settings > Privacy > Location to enable them for Play" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            
            [alertController addAction:ok];
            [alertController addAction:cancel];
            
        }
        
    }
    
}

-(void)setupLocationManager{
    if (_locationManager == nil) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = 10;
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startUpdatingLocation];
    
    
}



@end
