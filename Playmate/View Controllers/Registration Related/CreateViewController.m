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

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) ChisatoTextField *usernameField;
@property (strong, nonatomic) ChisatoTextField *passwordField;
@property (strong, nonatomic) ChisatoTextField *firstNameField;
@property (strong, nonatomic) ChisatoTextField *lastNameField;
@property (strong, nonatomic) ChisatoTextField *emailField;

@property (strong, nonatomic) UIDatePicker *birthdayPicker;
@property (strong, nonatomic) UIPickerView *genderPicker;

@end

@implementation CreateViewController

NSArray *genders;
NSString *selectedGender;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.usernameField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 230, 250, 60)];
    self.usernameField.placeholder = @"Username";
    [self.usernameField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.usernameField.borderColor = [UIColor systemGray6Color];
    self.usernameField.activeColor = [Constants playmateBlue];
    self.usernameField.textColor = [UIColor systemGray3Color];
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.passwordField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 290, 250, 60)];
    self.passwordField.placeholder = @"Password";
    [self.passwordField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.passwordField.borderColor = [UIColor systemGray6Color];
    self.passwordField.activeColor = [Constants playmateBlue];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.firstNameField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 350, 250, 60)];
    self.firstNameField.placeholder = @"First Name";
    [self.firstNameField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.firstNameField.borderColor = [UIColor systemGray6Color];
    self.firstNameField.activeColor = [Constants playmateBlue];
    self.firstNameField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.lastNameField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 410, 250, 60)];
    self.lastNameField.placeholder = @"Last Name";
    [self.lastNameField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.lastNameField.borderColor = [UIColor systemGray6Color];
    self.lastNameField.activeColor = [Constants playmateBlue];
    self.lastNameField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    self.emailField = [[ChisatoTextField alloc] initWithFrame:CGRectMake(72, 470, 250, 60)];
    self.emailField.placeholder = @"Email";
    [self.emailField setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.emailField.borderColor = [UIColor systemGray6Color];
    self.emailField.activeColor = [Constants playmateBlue];
    self.emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailField.spellCheckingType = UITextSpellCheckingTypeNo;
    
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.firstNameField];
    [self.view addSubview:self.lastNameField];
    [self.view addSubview:self.emailField];

    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    
    UILabel *genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 550, 100, 30)];
    genderLabel.text = @"Gender";
    [genderLabel setFont:[UIFont fontWithName:@"Avenir" size:16]];
    genderLabel.textColor = [UIColor systemGray3Color];
    [self.view addSubview:genderLabel];
    
    self.genderPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(72, 550, 250, 120)];
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    
    UILabel *birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 670, 100, 30)];
    birthdayLabel.text = @"Birthday";
    [birthdayLabel setFont:[UIFont fontWithName:@"Avenir" size:16]];
    birthdayLabel.textColor = [UIColor systemGray3Color];
    [self.view addSubview:birthdayLabel];
    
    self.birthdayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(72, 700, 250, 80)];
    self.birthdayPicker.datePickerMode = UIDatePickerModeDate;
    
    [self.view addSubview:self.genderPicker];
    [self.view addSubview:self.birthdayPicker];
    
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
