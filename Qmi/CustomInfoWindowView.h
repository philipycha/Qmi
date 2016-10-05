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

@end
