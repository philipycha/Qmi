//
//  Resturant.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "Resturant.h"

@interface Resturant() <PFSubclassing>

@end

@implementation Resturant

+(void)load{
    [self registerSubclass];
}

-(instancetype) init{
    self = [super initWithClassName:[Resturant parseClassName]];
    if (self) {
        self.queue = [[NSArray alloc]init];
    }
    return  self;
}

-(void) queueCustomer:(Customer *) customer{
    
    self.queue = [self.queue arrayByAddingObject:customer];
    
}

+(NSString *)parseClassName
{
    return  @"Restaurant";
}

@dynamic queue;

@end
