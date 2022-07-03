//
//  WelcomeViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 6/30/22.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation WelcomeViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customizeUI];
}

- (void)customizeUI {
    
    // For Create Account button
    self.createAccountButton.layer.cornerRadius = 20;
}

#pragma mark - Button Actions

- (IBAction)didTapCreate:(id)sender {
    [self performSegueWithIdentifier:@"createSegue" sender:nil];
}

- (IBAction)didTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"loginSegue" sender:nil];
}

@end
