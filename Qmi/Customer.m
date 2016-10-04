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

<<<<<<< HEAD
-(instancetype)initWithUser:(User *) user partySize:(NSString *) partySize andCurentLocation:(CLLocation *) currentLocation{
    self = [super init];
=======
+(void)load{
    [self registerSubclass];
}


@dynamic user;
@dynamic partySize;
@dynamic currentLocation;

-(instancetype)initWithUser:(User *) user partySize:(int) partySize andCurentLocation:(CLLocation *) currentLocation{
    self = [super initWithClassName:[Customer parseClassName]];
>>>>>>> master
    if (self) {
        self.user = [User currentUser];
        self.partySize = partySize;
        self.currentLocation = currentLocation;
    }
    return self;
}

+(NSString *)parseClassName
{
    return @"Customer";
}

@end
