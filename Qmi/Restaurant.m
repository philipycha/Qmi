//
//  Resturant.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "Restaurant.h"

@interface Restaurant() <PFSubclassing>

//@property (nonatomic) PFRelation <Customer *> *queueRelation;

@end

@implementation Restaurant

id<RestaurantDelegate> _delegate;

@dynamic numInQueue;
@dynamic user;
@dynamic name;

#pragma mark - Delegate getter/setter

-(id<RestaurantDelegate>)delegate
{
    return _delegate;
}

-(void)setDelegate:(id<RestaurantDelegate>)delegate
{
    _delegate = delegate;
}


#pragma mark - PFSubclassing

+(void)load{
    [self registerSubclass];
}

+(NSString *)parseClassName
{
    return  @"Restaurant";
}

#pragma mark - Public Methods

//Updates the passed in queue in the background
-(void) updateQueue{
    
    [self callSortedQueueWithCompletionBlock:^(NSArray<Customer *> * _Nullable queue, NSError * _Nullable error) {
        
        [self.delegate setControllerQueue:queue];
    }];

}

//Removes Customer from queue, advances the queue and updates the passed in array
-(void) removeCustomer:(Customer *) customer {
 
    __block int deletedCustomer = customer.queueNum;
    
    NSString *channel = [customer.user fetchIfNeeded].username;
    
    if(!channel){
        channel = @"";
    }
    
    [PFCloud callFunction:@"sendPushNotification" withParameters:@{@"AlertText":@"Removed from Queue", @"channel":channel}];
    
    //Remove customer from queue and delete them in the background
    customer.queueRestaurant = nil;
    if(self.numInQueue > 0)
    {
        self.numInQueue -= 1;
    }
    else{
        self.numInQueue = 0;
    }
    [customer deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error while deleting: %@", error);
        }
        //Advace customers behind the removed customer and update the queue
        [self callSortedQueueWithCompletionBlock:^(NSArray<Customer *> * _Nullable queue, NSError * _Nullable error) {
            for(int i = deletedCustomer; i < queue.count; i += 1){
                [queue[i] fetchIfNeeded].queueNum -= 1;
                
                
                NSString *channel = [queue[i].user fetchIfNeeded].username;
                
                if(!channel){
                    channel = @"";
                }
                
                [PFCloud callFunction:@"sendPushNotification" withParameters:@{@"AlertText":[NSString stringWithFormat:@"Moved to position %d", [queue[i] fetchIfNeeded].queueNum], @"channel":channel}];

                
                [queue[i] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error){
                        NSLog(@"Error while saving: %@", error);
                    }
                }];
            }
            [self updateQueue];
        }];
        
    }];
    
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving restaurant: %@", error);
        }
    }];
    
}


//Add a new customer to the restaurants queue
-(void) addCustomer:(Customer *_Nonnull) customer {
    customer.queueRestaurant = self;
    customer.queueNum = self.numInQueue;
    self.numInQueue += 1;
    
    [customer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error Saving: %@", error);
        }
    }];
    
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving restaurant: %@", error);
        }
    }];
    
    [self updateQueue];
    
}

#pragma mark - Private Methods



-(void) callSortedQueueWithCompletionBlock:(void (^_Nullable)(NSArray<Customer *> * _Nullable queue, NSError * _Nullable error))completionBlock
{
    PFQuery *query = [PFQuery queryWithClassName:[Customer parseClassName]];
    
    
    [query whereKey:@"queueRestaurant" equalTo:self];
    NSSortDescriptor *queueNumSort = [NSSortDescriptor sortDescriptorWithKey:@"queueNum" ascending:YES];
    [query orderBySortDescriptor:queueNumSort];
    

    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error getting objects %@", error);
        }
        
        
        if(completionBlock){
            if(objects){
                completionBlock(objects, error);
            }else{completionBlock(nil, error);}
        }
    }];
}




@end
