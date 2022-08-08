//
//  CreateViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "CreateViewController.h"
#import "CCTextFieldEffects.h"
#import "Helpers.h"
#import "Constants.h"
#import "Strings.h"

@interface CreateViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) YoshikoTextField *usernameField;

@end

@implementation CreateViewController

NSArray *genders;
NSString *selectedGender;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField = [[YoshikoTextField alloc] initWithFrame:CGRectMake(72, 260, 250, 70)];
    self.usernameField.placeholder = @"Username";
    [self.usernameField setFont:[UIFont fontWithName:@"Arial" size:15]];
    
    [self.view addSubview:self.usernameField];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    
    genders = [Constants gendersList];
    selectedGender = genders[0];
    
    [self.logoImageView setImage:[Constants profileImagePlaceholder]];
}

#pragma mark - Text fields

// Resign keyboard if user presses done
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.usernameField]) {
        [self.passwordField becomeFirstResponder];
    } else if ([textField isEqual:self.passwordField]) {
        [self.firstNameField becomeFirstResponder];
    } else if ([textField isEqual:self.firstNameField]) {
        [self.lastNameField becomeFirstResponder];
    } else if ([textField isEqual:self.lastNameField]) {
        [self.emailField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return true;
}

// Resign keyboard if user touches screen
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Gender picker view

// returns the number of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return genders.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return genders[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedGender = genders[row];
}

#pragma mark - Registration with Parse

- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set pfuser properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // add non-default properties to pfuser
    [newUser addObject:self.firstNameField.text forKey:@"firstName"];
    [newUser addObject:self.lastNameField.text forKey:@"lastName"];
    [newUser addObject:selectedGender forKey:@"gender"];
    
    NSDate *date = self.birthdayPicker.date;
    [newUser addObject:date forKey:@"birthday"];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        } else {
            [self performSegueWithIdentifier:@"createToLogin" sender:nil];
        }
    }];
}

- (IBAction)didTapProceed:(id)sender {
    [self registerUser];
}

@end
