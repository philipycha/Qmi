//
//  LocationManager.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager () <CLLocationManagerDelegate>

@property (nonatomic) BOOL firedOnce;

@end

@implementation LocationManager

+(LocationManager *) sharedLocationManager{
    static LocationManager *sharedLocationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationManager = [[LocationManager alloc]init];
    });
    return sharedLocationManager;
}


- (void)startLocationMonitoring{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        if ((!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            [self setupLocationManager];
            
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Location services are disabled, Please go into Settings > Privacy > Location to enable them for Usage" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
        
        _firedOnce = NO;
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _locationManager.distanceFilter = 50;
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //[_locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        
        [self.locationManager startUpdatingLocation]; //change to start updating instead of request
    
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (howRecent < 10.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
       
        self.currentLocation = location;
        
        
        NSLog(@"location updated");
        
        if (self.currentLocation != nil){
       
            [self.delegate updateCamera];
       
  
            if(!self.firedOnce){
            [self.delegate getRestaurantLocation];
                self.firedOnce = YES;
                NSLog(@"fired once");
               [self.locationManager stopUpdatingLocation];
            }
            
            NSLog(@"not nil");
        }
        
        
    }
    
}


@end
