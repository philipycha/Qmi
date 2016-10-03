//
//  Resturant.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "Resturant.h"

@implementation Resturant

-(instancetype) init{
    self = [super init];
    if (self) {
        _queue = [[NSArray alloc]init];
    }
    return  self;
}

-(void) queueCustomer:(Customer *) customer{
    
    self.queue = [self.queue arrayByAddingObject:customer];
    
}

@end
