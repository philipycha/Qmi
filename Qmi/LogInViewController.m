//
//  LogInViewController.m
//  Qmi
//
//  Created by Shaun Campbell on 2016-10-04.
//  Copyright © 2016 Philip Ha. All rights reserved.
//

#import "LogInViewController.h"
#import "User.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LogInViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    [self showUpSignUpAlert];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    
}


#pragma mark - self Functions

- (void)showUpSignUpAlert
{
    
    __block UITextField *emailAlertTextField;
    __block UITextField *passwordAlertTextField;
    __block UITextField *confirmPasswordAlertTextField;

    
    UIAlertController *signUpAlert = [UIAlertController alertControllerWithTitle:@"New Account" message:@"please enter your details" preferredStyle:UIAlertControllerStyleAlert];
    
    [signUpAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"email";
        emailAlertTextField = textField;
        if(self.emailTextField.text != nil)
        {
            textField.text = self.emailTextField.text;
        }
    }];
    
    [signUpAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        passwordAlertTextField = textField;
        textField.secureTextEntry = YES;
        textField.placeholder = @"password";
        if(self.passwordTextField.text != nil)
        {
            textField.text = self.passwordTextField.text;
        }
    }];
    
    [signUpAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        confirmPasswordAlertTextField = textField;
        textField.placeholder = @"confirm password";
        textField.secureTextEntry = YES;
    }];
    
    [signUpAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [signUpAlert addAction:[UIAlertAction actionWithTitle:@"Sign Up" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([passwordAlertTextField.text isEqualToString:confirmPasswordAlertTextField.text])
        {
            User *newUser = [[User alloc] init];
            newUser.username = emailAlertTextField.text;
            newUser.password = passwordAlertTextField.text;
            newUser.email = emailAlertTextField.text;
            newUser.isCustomer = YES;
            
            
            if([newUser signUp]){
                [self performSegueWithIdentifier:@"ShowCustomerMainView" sender:self];
            }else{
                [self presentSignUpFailedAlert:@"Username is taken"];
            }
        }
        else{
            [self presentSignUpFailedAlert:@"Passwords do not match"];
        }
        
    }]];
    
    [self presentViewController:signUpAlert animated:YES completion:^{
        
    }];
    
    
    
}

-(void)presentSignUpFailedAlert:(NSString*)message{
    UIAlertController *signUpFailedAlert = [UIAlertController alertControllerWithTitle:@"Sign Up Failed" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [signUpFailedAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    
    
    
}




@end
