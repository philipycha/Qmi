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
    [self logIn];
}

- (IBAction)emailEnterButtonPressed:(UITextField *)sender {
    [self.passwordTextField becomeFirstResponder];
}

- (IBAction)passwordEnterButtonPressed:(UITextField *)sender {
    [self logIn];
}



#pragma mark - self methods

-(void)logIn{
    if([User logInWithUsername:self.emailTextField.text password:self.passwordTextField.text]){
        
        User *currentUser = [User currentUser];
        
        if(currentUser.isCustomer)
        {
            [self performSegueWithIdentifier:@"ShowCustomerMainView" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"ShowRestaurantQueue" sender:self];
        }
        
    }else{
        [self presentBasicAlertWithTitle:@"Login Failed" andMessage:@""];
    }
}

- (void)showUpSignUpAlert
{
    
    __block UITextField *emailAlertTextField;
    __block UITextField *passwordAlertTextField;
    __block UITextField *confirmPasswordAlertTextField;
    __block UITextField *fullNameAlertTextField;
    __block UITextField *phoneNumberAlertTextField;

    
    UIAlertController *signUpAlert = [UIAlertController alertControllerWithTitle:@"New Account" message:@"please enter your details" preferredStyle:UIAlertControllerStyleAlert];
    
    [signUpAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"full name";
        fullNameAlertTextField = textField;
        
    }];
    
    [signUpAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.placeholder = @"phone number";
        phoneNumberAlertTextField = textField;
        
    }];
    
    [signUpAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
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
            newUser.name = fullNameAlertTextField.text;
            newUser.phoneNumber = phoneNumberAlertTextField.text;
            
            newUser.isCustomer = YES;
            
            
            
            
            if([newUser signUp]){
                [self performSegueWithIdentifier:@"ShowCustomerMainView" sender:self];
            }else{
                [self presentBasicAlertWithTitle:@"Sign Up Failed" andMessage:@"Username is taken"];
            }
        }
        else{
            [self presentBasicAlertWithTitle:@"Sign Up Failed" andMessage:@"Passwords do not match"];
        }
        
    }]];
    
    [self presentViewController:signUpAlert animated:YES completion:^{
        
    }];
    
    
    
}

-(void)presentBasicAlertWithTitle:(NSString *)title andMessage:(NSString*)message{
    
    UIAlertController *signUpFailedAlert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [signUpFailedAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:signUpFailedAlert animated:YES completion:nil];
}



//sets the channel of the phone (currentInstallation) to be the username of the logged in user
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    User *currentUser = [User currentUser];
    [self setInstallationChannelToEmail:currentUser];
}


//Sets the phones (installations) channel to the users username
-(void)setInstallationChannelToEmail:(User *)currentUser{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    NSString *userName = [currentUser fetchIfNeeded].username;
    [currentInstallation setChannels:@[userName]];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(error){
            NSLog(@"Error saving installation: %@", error);
        }
        else {
            NSLog(@"Successfully saved user installation");
        }
    }];
}


@end
