//
//  Customer.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "Customer.h"

@implementation Customer

-(instancetype)initWithUser:(User *) user partySize:(NSString *) partySize andCurentLocation:(CLLocation *) currentLocation{
    self = [super init];
    if (self) {
        _user = [User sharedUser];
        _partySize = partySize;
        _currentLocation = currentLocation;
    }
    return self;
}

@end
