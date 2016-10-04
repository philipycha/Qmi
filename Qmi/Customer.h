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

@interface Customer : PFObject

@property (nonatomic) NSString * partySize;
@property (nonatomic, strong) User * user;
@property (nonatomic) CLLocation * currentLocation;

-(instancetype)initWithUser:(User *) user partySize:(int) partySize andCurentLocation:(CLLocation *) currentLocation;

@end
