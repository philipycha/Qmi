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

@interface Customer : NSObject

@property (nonatomic) NSString* partySize;
@property (nonatomic, strong) User * user;
@property (nonatomic) CLLocation * currentLocation;

-(instancetype)initWithUser:(User *) user partySize:(NSString *) partySize andCurentLocation:(CLLocation *) currentLocation;

@end
