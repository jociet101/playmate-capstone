//
//  FriendRequestsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import "FriendRequestsViewController.h"

@interface FriendRequestsViewController ()

@property (weak, nonatomic) IBOutlet UIView *incomingView;
@property (weak, nonatomic) IBOutlet UIView *outgoingView;
@property (weak, nonatomic) IBOutlet UIView *invitationsView;

@end

@implementation FriendRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.incomingView.alpha = 1;
    self.outgoingView.alpha = 0;
    self.invitationsView.alpha = 0;
}

- (IBAction)switchViewController:(id)sender {
    
    UISegmentedControl *switcher = sender;
    
    self.incomingView.alpha = (switcher.selectedSegmentIndex == 0) ? 1 : 0;
    self.outgoingView.alpha = (switcher.selectedSegmentIndex == 1) ? 1 : 0;
    self.invitationsView.alpha = (switcher.selectedSegmentIndex == 2) ? 1 : 0;
}

@end
