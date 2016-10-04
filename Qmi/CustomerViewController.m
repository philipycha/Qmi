//
//  CustomerViewController.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "CustomerViewController.h"
@import GooglePlaces;
@import GoogleMaps;
#import "LocationManager.h"

@interface CustomerViewController () <locationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *joinQButton;
@property (nonatomic, strong) Resturant * selectedRestaurant;
@property (nonatomic, strong) LocationManager * locationManager;
@property (nonatomic, strong) GMSMapView * mapView;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [LocationManager sharedLocationManager];
    [self.locationManager startLocationMonitoring];
    self.locationManager.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.currentLocation.coordinate.latitude
                                                            longitude:self.locationManager.currentLocation.coordinate.longitude
                                                                 zoom:13];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;

    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *styleUrl = [mainBundle URLForResource:@"style" withExtension:@"json"];
    NSError *error;
    
    // Set the map style by passing the URL for style.json.
    GMSMapStyle *style = [GMSMapStyle styleWithContentsOfFileURL:styleUrl error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    
    mapView.mapStyle = style;
    self.mapView = mapView;
    self.view = mapView;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(self.locationManager.currentLocation.coordinate.latitude, self.locationManager.currentLocation.coordinate.longitude);
    marker.title = @"ME";
    marker.map = mapView;

    NSLog(@"user location:%@", mapView.myLocation);
    NSLog(@"location manager user location:%@", self.locationManager.currentLocation);
}

-(void)updateCamera{
    GMSCameraPosition *updatedCamera = [GMSCameraPosition cameraWithLatitude:self.locationManager.currentLocation.coordinate.latitude
                                                            longitude:self.locationManager.currentLocation.coordinate.longitude
                                                                 zoom:13];
    self.mapView.camera = updatedCamera;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)joinQButtonPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Party Info" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    
 
    __block UITextField *sizeOfPartyTextField;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        sizeOfPartyTextField = textField;
        
    }];
    
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        

        Customer *newCustomer = [[Customer alloc]init];
//      replace init with initWith... once CoreLocation and User are linked
        
        newCustomer.partySize = sizeOfPartyTextField.text;        
        NSLog(@"%@", newCustomer.partySize);
        
        
        [self.selectedRestaurant queueCustomer:newCustomer];
        
    }];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
