//
//  SessionDetailsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionDetailsViewController.h"
#import "SessionCell.h"
#import "Constants.h"

@interface SessionDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addMyselfButton;
@property (weak, nonatomic) IBOutlet UILabel *disabledButton;

@end

@implementation SessionDetailsViewController

PFUser *me;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    me = [PFUser currentUser];
    [me fetchIfNeeded];

    self.addMyselfButton.layer.cornerRadius = [Constants buttonCornerRadius];
    
    [self disableAddButton];
    
    [self initializeDetails];
}

- (void)disableAddButton {
    
    for (PFUser *user in self.sessionDeets.playersList) {
        [user fetchIfNeeded];
        
        if ([me.username isEqualToString:user.username]) {
            
            self.disabledButton.text = [Constants alreadyInSessionErrorMsg];
            self.disabledButton.textColor = [UIColor redColor];
            [self.addMyselfButton setEnabled:NO];
            self.addMyselfButton.alpha = 0;
            break;
        }
    }
    
    if ([self.sessionDeets.occupied isEqual:self.sessionDeets.capacity]) {
        self.disabledButton.text = [Constants fullSessionErrorMsg];
        self.disabledButton.textColor = [UIColor redColor];
        [self.addMyselfButton setEnabled:NO];
        self.addMyselfButton.alpha = 0;
    }
}

- (void)initializeDetails {
    
    self.sportLabel.text = self.sessionDeets.sport;
    
    // Form the fraction into a string
    NSString *capacityString = [Constants capacityString:self.sessionDeets.occupied with:self.sessionDeets.capacity];
    
    if ([self.sessionDeets.capacity isEqual:self.sessionDeets.occupied]) {
        self.capacityLabel.text = [Constants noOpenSlotsErrorMsg];
    } else {
        self.capacityLabel.text = capacityString;
    }
    
    self.levelLabel.text = self.sessionDeets.skillLevel;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Constants dateFormatString];
    NSString *originalDate = [formatter stringFromDate:self.sessionDeets.occursAt];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    self.dateTimeLabel.text = [formatter stringFromDate:date];
}

- (IBAction)addMyself:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.sessionDeets.objectId
                                 block:^(PFObject *session, NSError *error) {
        
        // Add myself to the session
        NSMutableArray *oldPlayersList = (NSMutableArray *)session[@"playersList"];
        [oldPlayersList addObject:me];
        
        session[@"playersList"] = (NSArray *)oldPlayersList;
        
        int oldOccupied = [session[@"occupied"] intValue] + 1;
        session[@"occupied"] = [NSNumber numberWithInt:oldOccupied];
        
        [session saveInBackground];
    }];
    
}

@end
