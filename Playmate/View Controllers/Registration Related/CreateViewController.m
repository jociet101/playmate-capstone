//
//  CreateViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/3/22.
//

#import "CreateViewController.h"

@interface CreateViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UIView *textFieldContainer;
@property (weak, nonatomic) IBOutlet UIView *pickerContainer;

@end

@implementation CreateViewController

NSMutableArray *genders;
int originalYOrigin;
NSString *selectedGender;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    
    selectedGender = @"Female";
    
    self.genderPicker.delegate = self;
    self.genderPicker.dataSource = self;
    
    genders = [[NSMutableArray alloc] init];
    [genders addObject:@"Female"];
    [genders addObject:@"Male"];
    [genders addObject:@"Add more"];
    
    CGRect containerFrame = self.textFieldContainer.frame;
    originalYOrigin = containerFrame.origin.y;
}

#pragma mark - Text fields

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        [self moveContainerBy:-40];
    } else if ([textField isEqual:self.passwordField]) {
        [self moveContainerBy:-40];
    } else if ([textField isEqual:self.firstNameField]) {
        [self moveContainerBy:-40];
    } else if ([textField isEqual:self.lastNameField]) {
        [self moveContainerBy:-40];
    } else if ([textField isEqual:self.emailField]) {
        [self moveContainerBy:-45];
    } else {
        [self moveContainerBy:0];
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self moveContainerBy:0];
}

- (void)moveContainerBy:(int)amount {
    [UIView animateWithDuration:0.5 animations:^{
    
        CGRect containerFrame = self.textFieldContainer.frame;
        containerFrame.origin.y = originalYOrigin + amount;
        
        self.textFieldContainer.frame = containerFrame;
    }];
}

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

- (void)handleAlert:(NSError *)error withTitle:(NSString *)title andOk:(NSString *)ok {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self viewDidLoad];
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated: YES completion: nil];
}

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
    
//    NSString *fullName = [self.firstNameField.text stringByAppendingString:[@" " stringByAppendingString:self.lastNameField.text]];
//    [newUser addObject:fullName forKey:@"fullName"];

    [newUser addObject:selectedGender forKey:@"gender"];
    
    NSDate *date = self.birthdayPicker.date;
    [newUser addObject:date forKey:@"birthday"];
//    [newUser addObject:nil forKey:@"profileImage"];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self handleAlert:error withTitle:@"Error" andOk:@"Try again"];
        } else {
            NSLog(@"User registered successfully");
            [self performSegueWithIdentifier:@"createToLogin" sender:nil];
        }
    }];
}

- (IBAction)didTapProceed:(id)sender {
    [self registerUser];
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
