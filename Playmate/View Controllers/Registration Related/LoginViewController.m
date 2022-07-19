//
//  LoginViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "Helpers.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    self.proceedButton.layer.cornerRadius = [Constants buttonCornerRadius];
}

#pragma mark - Text fields

// Resign keyboard if user presses done
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return true;
}

// Resign keyboard if user touches screen
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Login user with Parse

- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [Helpers handleAlert:error withTitle:@"Error" withMessage:nil forViewController:self];
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginToTab" sender:nil];
        }
    }];
}

- (IBAction)didTapProceed:(id)sender {
    [self loginUser];
}

@end
