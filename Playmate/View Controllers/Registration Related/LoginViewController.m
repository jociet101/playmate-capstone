//
//  LoginViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "LoginViewController.h"
#import "CCTextFieldEffects.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) ChisatoTextField *usernameField;
@property (strong, nonatomic) ChisatoTextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    self.usernameField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 310, 250, 60)];
    self.usernameField.placeholder = @"Username";
    [self.usernameField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.usernameField.borderColor = [UIColor systemGray6Color];
    self.usernameField.activeColor = [Constants playmateBlue];
    self.usernameField.textColor = [UIColor systemGray3Color];
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.passwordField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 380, 250, 60)];
    self.passwordField.placeholder = @"Password";
    [self.passwordField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.passwordField.borderColor = [UIColor systemGray6Color];
    self.passwordField.activeColor = [Constants playmateBlue];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];

    [Helpers setCornerRadiusAndColorForButton:self.proceedButton andIsSmall:NO];
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
            self.usernameField.text = @"";
            self.passwordField.text = @"";
            [self.usernameField resignFirstResponder];
            [self.passwordField resignFirstResponder];
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        } else {
            [self performSegueWithIdentifier:@"loginToTab" sender:nil];
        }
    }];
}

- (IBAction)didTapProceed:(id)sender {
    [self.proceedButton setBackgroundColor:[Constants playmateBlueSelected]];
    [self loginUser];
}

@end
