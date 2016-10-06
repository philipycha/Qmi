//
//  Customer.h
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "User.h"
#import <Parse/Parse.h>

@class Restaurant;

@interface Customer : PFObject

@property (nonatomic) NSString * partySize;
@property (nonatomic) NSString * name;
@property (nonatomic, strong) User * user;
@property (nonatomic) NSString *distance;
@property (nonatomic) Restaurant *queueRestaurant;
@property (nonatomic, assign) int queueNum;

+(Customer *)customerWithUser:(User *) user partySize:(NSString *) partySize andDistance:(NSString *) distance;
+(NSString *)parseClassName;

@end
