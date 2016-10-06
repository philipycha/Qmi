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
#import <Parse/Parse.h>
#import "RestaurantMarker.h"
#import "LocationManager.h"
#import "CustomInfoWindowView.h"
#import "BasicInfoWindowView.h"
#import <QuartzCore/QuartzCore.h>
#import "ViewUpdateDelegate.h"
#import "AppDelegate.h"

@interface CustomerViewController () <locationManagerDelegate, GMSMapViewDelegate, ViewUpdateDelegate>

@property (nonatomic, strong) Restaurant * selectedRestaurant;
@property (nonatomic, strong) LocationManager * locationManager;
@property (nonatomic, strong) GMSMapView * mapView;
@property (nonatomic, strong) NSURLSession * markerSession;
@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic) CustomInfoWindowView * infoWindow;
@property (nonatomic, strong) NSString *currentPageToken;
@property (nonatomic, strong) NSString *lastPageToken;
@property (assign) int counter;
@property (weak, nonatomic) IBOutlet UIView *queueView;
@property (weak, nonatomic) IBOutlet UILabel *queueRestLabel;
@property (weak, nonatomic) IBOutlet UILabel *quePositionLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeQueueButton;
@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set view update delegate to self
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    appDelegate.delegate = self;
    
    self.locationManager = [LocationManager sharedLocationManager];
    [self.locationManager startLocationMonitoring];
    self.locationManager.delegate = self;
    
    self.currentPageToken  = @"111";
    self.lastPageToken = @"000";
    self.counter = 0;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.locationManager.currentLocation.coordinate.latitude
                                                            longitude:self.locationManager.currentLocation.coordinate.longitude
                                                                 zoom:15];
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
   

    
    
    self.queueRestLabel.text = @"Phil's Brothel";
    self.quePositionLabel.text = @"3";
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
    //self.view = mapView;
    
    self.queueView.layer.cornerRadius = 5;
    self.queueView.layer.masksToBounds = YES;
    self.queueView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5f];
    [self.view insertSubview: self.mapView atIndex: 0];
    [self.view insertSubview: self.queueView aboveSubview:mapView];
    
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
    
}

-(NSMutableArray *)restaurants{
    if(!_restaurants){
        self.restaurants = [[NSMutableArray alloc] init];
    }
    return _restaurants;
}


-(void)updateCamera{
    GMSCameraPosition *updatedCamera = [GMSCameraPosition
                                        cameraWithLatitude:self.locationManager.currentLocation.coordinate.latitude
                                        longitude:self.locationManager.currentLocation.coordinate.longitude
                                        zoom:15 bearing:0
                                        viewingAngle:45.0];
    self.mapView.camera = updatedCamera;
    
}

-(void)fetchRestaurantsWithURL:(NSString *)urlString{
    
    self.counter = self.counter + 1;
    
    NSLog(@"succesfully completed %i counter", self.counter);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(!error)
        {
            
            NSError *jsonError = nil;
            NSDictionary *dictFromJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSArray *restaurantsFromJSONDict = [dictFromJSON objectForKey:@"results"];
            
            
            PFQuery *query = [PFQuery queryWithClassName:[Restaurant parseClassName]];
            NSArray *parseRestaurants = [query findObjects];
            NSSet *parseRestaurantsSet = [[NSSet alloc] init];
            if(parseRestaurants)
            {
                parseRestaurantsSet = [NSSet setWithArray:parseRestaurants];
            }
            
            
            
            for (NSDictionary *restaurant in restaurantsFromJSONDict)
            {
                NSString *name = [restaurant objectForKey:@"name"];
                NSString *address = [restaurant objectForKey:@"formatted_address"];
                NSString *rating = [restaurant objectForKey:@"rating"];
                NSDictionary *geometry = [restaurant objectForKey:@"geometry"];
                NSDictionary *location = [geometry objectForKey:@"location"];
                NSNumber *lat = [location objectForKey:@"lat"];
                NSNumber *lng = [location objectForKey:@"lng"];
                //NSLog(@"CURRENT LATITUDE: %@", lat);
                CLLocationCoordinate2D restaurantLocation = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                GoogleMapsRestaurant *newRestaurant = [[GoogleMapsRestaurant alloc] initWithName:name address:address rating: rating andCoordinate:restaurantLocation];
                
                for(Restaurant *restaurant in parseRestaurantsSet)
                {
                    if([restaurant.name isEqualToString:name])
                    {
                        newRestaurant.restaurant = restaurant;
                        break;
                    }
                }
                
                
                
                [self.restaurants addObject:newRestaurant];
                
                
            }
            
            self.currentPageToken = [dictFromJSON objectForKey:@"next_page_token"];
            
            //NSLog(@"LAST PAGE TOKEN : %@",self.lastPageToken);
            NSLog(@"Current PAGE TOKEN: %@",self.currentPageToken);
            
            if(self.currentPageToken != nil && ![self.lastPageToken isEqualToString:self.currentPageToken]){
                
                self.lastPageToken = self.currentPageToken;
                
                [self fetchRestaurantsWithURL:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken=%@&key=AIzaSyCPxkehcAiAEjrK-Ba6r2I7KR7vldh9dUM", self.currentPageToken]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self passMarkerInfo];
                
            });
        }
    }];
    
    
    [dataTask resume];
}

-(void)getRestaurantLocation
{
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=5000&type=restaurant&key=AIzaSyCPxkehcAiAEjrK-Ba6r2I7KR7vldh9dUM", self.locationManager.currentLocation.coordinate.latitude, self.locationManager.currentLocation.coordinate.longitude];
    
    [self fetchRestaurantsWithURL:urlString];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)passMarkerInfo{
    
    for (GoogleMapsRestaurant *restaurant in self.restaurants) {
        
        
        
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(restaurant.coordinate.latitude, restaurant.coordinate.longitude);
        RestaurantMarker *restaurantMarker = [RestaurantMarker markerWithPosition:position];
        restaurantMarker.title = restaurant.name;
        if(restaurant.restaurant){
            restaurantMarker.icon = [UIImage imageNamed:@"Qmi-Pin"];
            restaurantMarker.icon = [self image:restaurantMarker.icon scaledToSize:CGSizeMake(40.0f, 50.0f)];
            restaurantMarker.restaurant = restaurant.restaurant;
        }
        else{
            restaurantMarker.iconView.backgroundColor = [UIColor purpleColor];
        }
        restaurantMarker.snippet = restaurant.rating;
       
        restaurantMarker.map = self.mapView;
        
        
        
    }
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    RestaurantMarker *restaurantMarker = (RestaurantMarker *)marker;
    if(restaurantMarker.restaurant){
        [self joinQButtonPressed:restaurantMarker.restaurant];
    }
    
    //add else to do something for regular markers
    
}

-(UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
    
    RestaurantMarker *restaurantMarker = (RestaurantMarker*) marker;
    
    if(restaurantMarker.restaurant){
        CustomInfoWindowView *infoWindow = [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoWindow" owner:self options:nil] objectAtIndex:0];
        infoWindow.RestaurantNameLabel.text = marker.title;
        infoWindow.QueueSizeLabel.text = [NSString stringWithFormat:@"%d", restaurantMarker.restaurant.numInQueue];
        infoWindow.delegate = self;
        [infoWindow showRating:marker.snippet];
        return infoWindow;
    }
    else{
        
        BasicInfoWindowView *basicInfoWindow = [[[NSBundle mainBundle] loadNibNamed:@"BasicInfoWindow" owner:self options:nil] objectAtIndex:0];
        basicInfoWindow.restaurantTitleLabel.text = marker.title;
        return basicInfoWindow;
    }

}

-(void)joinQButtonPressed:(Restaurant *)restaurant{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Party Info" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    
    
    __block UITextField *sizeOfPartyTextField;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        textField.placeholder = @"How Big is your party?";
        sizeOfPartyTextField = textField;
        
    }];
    
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        Customer *newCustomer = [Customer customerWithUser:[User currentUser] partySize:sizeOfPartyTextField.text andDistance:@"Calculate this"];
        [restaurant addCustomer:newCustomer];
        
        [newCustomer saveInBackground];
        [restaurant saveInBackground];
        
        NSString *channel = [restaurant.user fetchIfNeeded].username;
        if(channel == nil){
            channel = @"";
        }
        
        [PFCloud callFunction:@"sendPushNotification" withParameters:@{@"AlertText":@"a new customer has been added to your Queue", @"channel":channel}];
        
    }];
    
    UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:closeAction];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}


#pragma mark - ViewUpdateDelegate

-(void)updateUsersView
{
    //Update the Customer view
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
