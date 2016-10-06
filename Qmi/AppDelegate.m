//
//  AppDelegate.m
//  Qmi
//
//  Created by Philip Ha on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Restaurant.h"
#import "Customer.h"
@import GoogleMaps;
@import GooglePlaces;
@import UserNotifications;
#import <YelpAPI/YelpAPI.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Connect to parse
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"Qmi";
        configuration.server = @"https://qmi.herokuapp.com/parse";
    }]];
    
    //Google Maps API Keys
    [GMSPlacesClient provideAPIKey:@"AIzaSyCPxkehcAiAEjrK-Ba6r2I7KR7vldh9dUM"];
    [GMSServices provideAPIKey:@"AIzaSyCS_ydZKmNjxd6nzKQ6jxX5wWihgvkZovk"];
    
   
    
    //Check if there is a user cached on the device and send them to the correct storyboard
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //push notifications
    
    
    [self registerForRemoteNotifications];

    
    
    if([User currentUser])
    {
        User *currentUser = [User currentUser];
        
        [self setInstallationChannelToEmail:currentUser];
        
        if(currentUser.isCustomer){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CustomerMainView" bundle:[NSBundle mainBundle]];
            
            self.window.rootViewController = [storyboard instantiateInitialViewController];
            
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RestaurantQueue" bundle:[NSBundle mainBundle]];
            self.window.rootViewController = [storyboard instantiateInitialViewController];
        }
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LogIn" bundle:[NSBundle mainBundle]];
        self.window.rootViewController = [storyboard instantiateInitialViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
   

}

# pragma Mark - Push Notifications

- (void)registerForRemoteNotifications {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
        if(!error){
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
}

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [self.delegate updateUsersView];
    [PFPush handlePush:userInfo];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//Sets the phones (installations) channel to the users username
-(void)setInstallationChannelToEmail:(User *)currentUser{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *userName = [currentUser fetchIfNeeded].username;
    [currentInstallation setChannels:@[userName]];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving installation: %@", error);
        }
        else {
            NSLog(@"Successfully saved user installation");
        }
    }];
}

@end
