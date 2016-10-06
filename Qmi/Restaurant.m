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
-(void) updateQueue:(NSArray<Customer *> *_Nonnull)queue withCompletionBlock:(void (^_Nullable)())completionBlock{

//    __block NSArray<Customer *> *blockRef = queue;
    
    [self callSortedQueue:queue withCompletionBlock:^(NSArray<Customer *> * _Nullable queue, NSError * _Nullable error) {
//        blockRef = queue;
        
        [self.delegate setControllerQueue:queue];
        if (completionBlock){
            completionBlock();
        }
    }];

}

//Removes Customer from queue, advances the queue and updates the passed in array
-(void) removeCustomer:(Customer *) customer fromQueue:(NSArray<Customer *> *)queue withCompletionBlock:(void (^_Nullable)())completionBlock{

    __block NSArray<Customer *> *blockRef = queue;
    __block int deletedCustomer = customer.queueNum;
    
    //Remove customer from queue and delete them in the background
    customer.queueRestaurant = nil;
    if(self.numInQueue > 0)
    {
        self.numInQueue -= 1;
    }
    [customer deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error while deleting: %@", error);
        }
        //Advace customers behind the removed customer and update the queue
        [self callSortedQueue:queue withCompletionBlock:^(NSArray<Customer *> * _Nullable queue, NSError * _Nullable error) {
            for(int i = deletedCustomer; i < queue.count; i += 1){
                customer.queueNum -= 1;
                [customer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if(error){
                        NSLog(@"Error while saving: %@", error);
                    }
                }];
            }
            [self updateQueue:blockRef withCompletionBlock:completionBlock];
        }];
        
    }];
    
    
    
}


//Add a new customer to the restaurants queue
-(void) addCustomer:(Customer *_Nonnull) customer toQueue:(NSArray<Customer *> *_Nonnull)queue withCompletionBlock:(void (^_Nullable)())completionBlock{
    customer.queueRestaurant = self;
    customer.queueNum = self.numInQueue;
    self.numInQueue += 1;
    
    [customer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error Saving: %@", error);
        }
    }];
    
    [self updateQueue:queue withCompletionBlock:completionBlock];
    
}

#pragma mark - Private Methods



-(void) callSortedQueue:(NSArray<Customer *> *)queue withCompletionBlock:(void (^_Nullable)(NSArray<Customer *> * _Nullable queue, NSError * _Nullable error))completionBlock
{
    PFQuery *query = [PFQuery queryWithClassName:[Customer parseClassName]];
    
    
    [query whereKey:@"queueRestaurant" equalTo:self];
    NSSortDescriptor *queueNumSort = [NSSortDescriptor sortDescriptorWithKey:@"queueNum" ascending:NO];
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
