//
//  Resturant.h
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Customer.h"
#import "User.h"

@protocol RestaurantDelegate <NSObject>

-(void)setControllerQueue:(NSArray<Customer *> *_Nonnull)queue;

@end

@interface Restaurant : PFObject

@property (nonatomic, assign) int numInQueue;
@property (nonatomic) User *_Nullable user;
@property (nonatomic, weak) id <RestaurantDelegate> _Nullable delegate;


-(void) addCustomer:(Customer *_Nonnull) customer toQueue:(NSArray<Customer *> *_Nonnull)queue withCompletionBlock:(void (^_Nullable)())completionBlock;
-(void) updateQueue:(NSArray<Customer *> *_Nonnull)queue withCompletionBlock:(void (^_Nullable)())completionBlock;
-(void) removeCustomer:(Customer *_Nonnull) customer fromQueue:(NSArray<Customer *> *_Nonnull)queue withCompletionBlock:(void (^_Nullable)())completionBlock;

@end
