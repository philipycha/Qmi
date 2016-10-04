//
//  User.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "User.h"

@implementation User

+(User *) sharedUser {
    static User *sharedUser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUser = [[User alloc]init];
    });
    return sharedUser;
}


@end
