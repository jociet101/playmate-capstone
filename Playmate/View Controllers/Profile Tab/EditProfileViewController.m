//
//  EditProfileViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/8/22.
//

#import "EditProfileViewController.h"
#import "Constants.h"

@interface EditProfileViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *firstNameView;
@property (weak, nonatomic) IBOutlet UITextView *lastNameView;
@property (weak, nonatomic) IBOutlet UITextView *bioView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.firstNameView.delegate = self;
    self.lastNameView.delegate = self;
    self.bioView.delegate = self;
    
    self.saveButton.layer.cornerRadius = [Constants buttonCornerRadius];
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    self.firstNameView.text = user[@"firstName"][0];
    self.lastNameView.text = user[@"lastName"][0];
    self.bioView.text = user[@"biography"][0];
    
}

- (IBAction)editFirstName:(id)sender {
    self.firstNameView.editable = YES;
    [self.firstNameView becomeFirstResponder];
}

- (IBAction)editLastName:(id)sender {
    self.lastNameView.editable = YES;
    [self.lastNameView becomeFirstResponder];
}

- (IBAction)editBio:(id)sender {
    self.bioView.editable = YES;
    [self.bioView becomeFirstResponder];
}

- (IBAction)didTapSave:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    [user fetchIfNeeded];
    
    [user removeObjectForKey:@"firstName"];
    [user addObject:self.firstNameView.text forKey:@"firstName"];
    
    [user removeObjectForKey:@"lastName"];
    [user addObject:self.lastNameView.text forKey:@"lastName"];
    
    if ([user objectForKey:@"biography"] != nil) {
        [user removeObjectForKey:@"biography"];
    }
    
    [user addObject:self.bioView.text forKey:@"biography"];
        
    [user saveInBackground];
        
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        textView.editable = NO;
        return true;
    }
    
    return true;
}

@end
