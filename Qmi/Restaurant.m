//
//  Resturant.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "Restaurant.h"

@interface Resturant() <PFSubclassing>

@property (nonatomic) PFRelation <Customer *> *queueRelation;

@end

@implementation Resturant

+(void)load{
    [self registerSubclass];
}

-(void)setQueue:(NSArray<Customer *> *)queue
{
    for(Customer *customer in queue)
    {
        [customer relationForKey:@"queueRelation"];
        [customer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(error)
            {
                NSLog(@"%@", error);
            }
        }];
    }
}

-(NSArray<Customer *> *)queue
{
    NSArray<Customer *> *queueArray = [[NSArray alloc] init];
    
    
    
    
    
    return queueArray;
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
