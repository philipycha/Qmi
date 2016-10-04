//
//  CustomerViewController.m
//  Qmi
//
//  Created by Tevin Maker on 2016-10-03.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "CustomerViewController.h"

@interface CustomerViewController ()
@property (strong, nonatomic) IBOutlet UIButton *joinQButton;
@property (nonatomic, strong) Resturant * selectedRestaurant;

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)joinQButtonPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Party Info" message:NULL preferredStyle:UIAlertControllerStyleAlert];
    
 
    __block UITextField *sizeOfPartyTextField;
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        
        sizeOfPartyTextField = textField;
        
    }];
    
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        

        Customer *newCustomer = [[Customer alloc]init];
//      replace init with initWith... once CoreLocation and User are linked
        
        newCustomer.partySize = sizeOfPartyTextField.text;
        
        [self.selectedRestaurant queueCustomer:newCustomer];
        
    }];
    
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];

    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
