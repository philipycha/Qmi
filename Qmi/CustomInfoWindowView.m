//
//  CustomInfoWindowView.m
//  
//
//  Created by Tevin Maker on 2016-10-04.
//
//

#import "CustomInfoWindowView.h"
#import "Customer.h"
#import "Resturant.h"

@interface CustomInfoWindowView ()
@property (nonatomic, strong) Resturant * selectedRestaurant;

@end

@implementation CustomInfoWindowView
- (IBAction)JoinQButtonPressed:(UIButton *)sender {
    
    [self.delegate joinQButtonPressed];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
