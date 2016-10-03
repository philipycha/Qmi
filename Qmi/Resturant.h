//
//  Resturant.h
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"
#import "User.h"

@interface Resturant : NSObject

@property (nonatomic, strong) NSArray <Customer *> * queue;

@end
