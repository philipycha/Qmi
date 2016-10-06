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

-(void)showRating:(NSString *)rating{
    
    int ratingInt = [rating intValue];
    
    switch (ratingInt) {
        case 1:
            self.starOne.image = [UIImage imageNamed:@"ratingStar"];
            break;
        case 2:
            self.starOne.image = [UIImage imageNamed:@"ratingStar"];
            self.starTwo.image = [UIImage imageNamed:@"ratingStar"];
            break;
        case 3:
            self.starOne.image = [UIImage imageNamed:@"ratingStar"];
            self.starTwo.image = [UIImage imageNamed:@"ratingStar"];
            self.starThree.image = [UIImage imageNamed:@"ratingStar"];
            break;
        case 4:
            self.starOne.image = [UIImage imageNamed:@"ratingStar"];
            self.starTwo.image = [UIImage imageNamed:@"ratingStar"];
            self.starThree.image = [UIImage imageNamed:@"ratingStar"];
            self.starFour.image = [UIImage imageNamed:@"ratingStar"];
            break;
        case 5:
            self.starOne.image = [UIImage imageNamed:@"ratingStar"];
            self.starTwo.image = [UIImage imageNamed:@"ratingStar"];
            self.starThree.image = [UIImage imageNamed:@"ratingStar"];
            self.starFour.image = [UIImage imageNamed:@"ratingStar"];
            self.starFive.image = [UIImage imageNamed:@"ratingStar"];
            break;
            
        default:
            break;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
