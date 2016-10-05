//
//  CustomerViewController.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "CustomerViewController.h"
#import "GoogleMapsRestaurant.h"
@import GooglePlaces;
@import GoogleMaps;

//https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+VancouverBC&sensor=true&key=AIzaSyCPxkehcAiAEjrK-Ba6r2I7KR7vldh9dUM
//JSON URL for VANCOUVER RESTAURANTS
#import "LocationManager.h"
#import "CustomInfoWindowView.h"

@interface CustomerViewController () <locationManagerDelegate, GMSMapViewDelegate, InfoWindowDelegate>

@property (strong, nonatomic) IBOutlet UIButton *joinQButton;
@property (nonatomic, strong) Resturant * selectedRestaurant;
@property (nonatomic, strong) LocationManager * locationManager;
@property (nonatomic, strong) GMSMapView * mapView;
@property (nonatomic, strong) NSURLSession * markerSession;
@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic) CustomInfoWindowView * infoWindow;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [LocationManager sharedLocationManager];
    [self.locationManager startLocationMonitoring];
    self.locationManager.delegate = self;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.currentLocation.coordinate.latitude
                                                            longitude:self.locationManager.currentLocation.coordinate.longitude
                                                                 zoom:15];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.delegate = self;

    
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
    
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;

    NSLog(@"user location:%@", mapView.myLocation);
    NSLog(@"location manager user location:%@", self.locationManager.currentLocation);
    

    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Current Place error %@", [error localizedDescription]);
            return;
        }
        
        for (GMSPlaceLikelihood *likelihood in likelihoodList.likelihoods) {
            GMSPlace* place = likelihood.place;
            NSLog(@"Current Place name %@ at likelihood %g", place.name, likelihood.likelihood);
            NSLog(@"Current Place address %@", place.formattedAddress);
            NSLog(@"Current Place attributions %@", place.attributions);
            NSLog(@"Current PlaceID %@", place.placeID);
        }
    }];

    [self markerInfoTest];
}


-(void)updateCamera{
    GMSCameraPosition *updatedCamera = [GMSCameraPosition cameraWithLatitude:self.locationManager.currentLocation.coordinate.latitude
                                                            longitude:self.locationManager.currentLocation.coordinate.longitude
                                                                 zoom:15];
    self.mapView.camera = updatedCamera;
    
}


-(void)getRestaurantLocation:(NSString*)location
{
    NSString *urlString = @"https://maps.googleapis.com/maps/api/place/textsearch/json?query=restaurants+in+VancouverBC&sensor=true&key=AIzaSyCPxkehcAiAEjrK-Ba6r2I7KR7vldh9dUM";
    urlString = [urlString stringByAppendingString:location];
    urlString = [urlString stringByAppendingString:@"&results="];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error)
        {
            NSError *jsonError = nil;
            NSDictionary *dictFromJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSArray *restaurantsFromJSONDict = [dictFromJSON objectForKey:@"results"];
            self.restaurants = [[NSMutableArray alloc] init];
            
            for (NSDictionary *restaurant in restaurantsFromJSONDict)
            {
                NSString *name = [restaurant objectForKey:@"name"];
                NSString *address = [restaurant objectForKey:@"address"];
                NSNumber *lat = [restaurant objectForKey:@"lat"];
                NSNumber *lng = [restaurant objectForKey:@"lng"];
                
                CLLocationCoordinate2D restaurantLocation = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                GoogleMapsRestaurant *newRestaurant = [[GoogleMapsRestaurant alloc] initWithName:name address:address andCoordinate:restaurantLocation];
                                                       
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
                
            }
        }
    }];
    [dataTask resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)markerInfoTest{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
    GMSMarker *london = [GMSMarker markerWithPosition:position];
    london.title = @"London";
    london.snippet = @"Population: 8,174,100";
    london.map = self.mapView;
    
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    [self joinQButtonPressed];
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    CustomInfoWindowView *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoWindow" owner:self options:nil] objectAtIndex:0];
    infoWindow.RestaurantNameLabel.text = @"";
    infoWindow.QueueSizeLabel.text = @"2";
    infoWindow.delegate = self;
    return infoWindow;
}

-(void)joinQButtonPressed{
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
