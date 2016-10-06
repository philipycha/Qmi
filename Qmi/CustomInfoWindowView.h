//
//  CustomInfoWindowView.h
//  
//
//  Created by Tevin Maker on 2016-10-04.
//
//

#import <UIKit/UIKit.h>

@protocol InfoWindowDelegate <NSObject>

-(void)joinQButtonPressed;

@end

@interface CustomInfoWindowView : UIView

@property (strong, nonatomic) IBOutlet UILabel *RestaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *QueueSizeLabel;
@property (nonatomic, strong) id <InfoWindowDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *starOne;
@property (strong, nonatomic) IBOutlet UIImageView *starTwo;
@property (strong, nonatomic) IBOutlet UIImageView *starThree;
@property (strong, nonatomic) IBOutlet UIImageView *starFour;
@property (strong, nonatomic) IBOutlet UIImageView *starFive;

-(void) showRating: (NSString *) rating;

@end
