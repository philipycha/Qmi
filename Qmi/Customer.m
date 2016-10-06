//
//  Customer.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "Customer.h"

@interface Customer() <PFSubclassing>

@end

@implementation Customer

+(void)load{
    [self registerSubclass];
}


@dynamic name;
@dynamic user;
@dynamic partySize;
@dynamic currentLocation;
@dynamic queueRestaurant;
@dynamic queueNum;

+(Customer *)customerWithUser:(User *) user partySize:(NSString *) partySize andCurentLocation:(CLLocation *) currentLocation{
    Customer *newCustomer = [Customer objectWithClassName:[Customer parseClassName]];
    
    newCustomer.partySize = partySize;
    newCustomer.user = user;
    newCustomer.currentLocation = currentLocation;
    
    return newCustomer;
}

+(NSString *)parseClassName
{
    return @"Customer";
}

@end
