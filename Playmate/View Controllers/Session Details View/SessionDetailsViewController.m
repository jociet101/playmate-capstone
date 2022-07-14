//
//  SessionDetailsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionDetailsViewController.h"
#import "SessionCell.h"
#import "Constants.h"
#import "Location.h"
#import "PlayerProfileCollectionCell.h"
#import "PlayerProfileViewController.h"

@interface SessionDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addMyselfButton;
@property (weak, nonatomic) IBOutlet UILabel *disabledButton;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;

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
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView reloadData];
}

- (void)disableAddButton {
    
    for (PFUser *user in self.sessionDetails.playersList) {
        [user fetchIfNeeded];
        
        if ([me.username isEqualToString:user.username]) {
            
            self.disabledButton.text = [Constants alreadyInSessionErrorMsg];
            self.disabledButton.textColor = [UIColor redColor];
            [self.addMyselfButton setEnabled:NO];
            self.addMyselfButton.alpha = 0;
            break;
        }
    }
    
    if ([self.sessionDetails.occupied isEqual:self.sessionDetails.capacity]) {
        self.disabledButton.text = [Constants fullSessionErrorMsg];
        self.disabledButton.textColor = [UIColor redColor];
        [self.addMyselfButton setEnabled:NO];
        self.addMyselfButton.alpha = 0;
    }
}

- (void)initializeDetails {
    
    self.sportLabel.text = self.sessionDetails.sport;
    
    // Form the fraction into a string
    NSString *capacityString = [Constants capacityString:self.sessionDetails.occupied with:self.sessionDetails.capacity];
    
    if ([self.sessionDetails.capacity isEqual:self.sessionDetails.occupied]) {
        self.capacityLabel.text = [Constants noOpenSlotsErrorMsg];
    } else {
        self.capacityLabel.text = capacityString;
    }
    
    self.levelLabel.text = self.sessionDetails.skillLevel;
    
    Location *loc = self.sessionDetails.location;
    [loc fetchIfNeeded];
    
    self.locationLabel.text = loc.locationName;
    
    [self setDate];
    
    self.createdDateLabel.text = [@"Session created at: " stringByAppendingString:[Constants formatDate:self.sessionDetails.updatedAt]];
}

- (void)setDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *startTime = self.sessionDetails.occursAt;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMinute:60*[self.sessionDetails.duration intValue]];
    NSDate *endTime = [gregorian dateByAddingComponents:comps toDate:startTime  options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Constants dateFormatString];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSString *dateString = [formatter stringFromDate:startTime];
    
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *startTimeString = [formatter stringFromDate:startTime];
    NSString *endTimeString = [formatter stringFromDate:endTime];
    
    self.dateTimeLabel.text = [dateString stringByAppendingFormat:@", %@ to %@", startTimeString, endTimeString];
}

- (IBAction)addMyself:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];

    // Retrieve the object by id
    [query getObjectInBackgroundWithId:self.sessionDetails.objectId
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

#pragma mark - Collection view protocol methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessionDetails.playersList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayerProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerProfileCollectionCell" forIndexPath:indexPath];
    
    cell.userProfile = self.sessionDetails.playersList[indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([sender isMemberOfClass:[PlayerProfileCollectionCell class]]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        PFUser* data = self.sessionDetails.playersList[indexPath.row];
        PlayerProfileViewController *VC = [segue destinationViewController];
        VC.user = data;
    }
}

@end
