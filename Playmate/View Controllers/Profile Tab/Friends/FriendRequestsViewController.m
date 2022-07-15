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

@end

@implementation FriendRequestsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.incomingView.alpha = 1;
    self.outgoingView.alpha = 0;
}

- (IBAction)switchViewController:(id)sender {
    
    UISegmentedControl *switcher = sender;
    
    const BOOL isSegmentZeroIndex = (switcher.selectedSegmentIndex == 0);
    self.incomingView.alpha = isSegmentZeroIndex ? 1 : 0;
    self.outgoingView.alpha = isSegmentZeroIndex ? 0 : 1;
    
}

@end
