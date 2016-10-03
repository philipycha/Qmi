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

@property (nonatomic) int partySize;
@property (nonatomic, strong) User * user;
@property (nonatomic) CLLocation * currentLocation;

@end
