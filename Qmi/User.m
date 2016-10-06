//
//  User.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "User.h"

@interface User() <PFSubclassing>

@end

@implementation User

+(User *)userWithName:(NSString *)name andPhoneNumber:(NSString *)phoneNumber andIsCustomer:(BOOL)isCustomer{
    User *newUser = [User user];
    
    newUser.name = name;
    newUser.phoneNumber = phoneNumber;
    newUser.isCustomer = isCustomer;
    
    return newUser;
}



+(User *)userCustomerWithName:(NSString *)name andPhoneNumber:(NSString *)phoneNumber{
    return [User userWithName:name andPhoneNumber:phoneNumber andIsCustomer:YES];
}

+(User *)userRestaurantWithName:(NSString *)name andPhoneNumber:(NSString *)phoneNumber{
    return [User userWithName:name andPhoneNumber:phoneNumber andIsCustomer:NO];
}


@dynamic name;
@dynamic phoneNumber;
@dynamic isCustomer;

@end
