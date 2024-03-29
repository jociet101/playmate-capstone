//
//  SessionDetailsViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import <QuartzCore/QuartzCore.h>
#import "SessionDetailsViewController.h"
#import "HomeViewController.h"
#import "PlayerProfileViewController.h"
#import "FriendsListViewController.h"
#import "PlayerProfileCollectionCell.h"
#import "ManageUserStatistics.h"
#import "RecommendationData.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NotificationHandler.h"
#import "SessionCell.h"
#import "Location.h"
#import "Invitation.h"
#import "APIManager.h"
#import "Helpers.h"
#import "Constants.h"
#import "Strings.h"

@interface SessionDetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UITextView *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addMyselfButton;
@property (weak, nonatomic) IBOutlet UILabel *disabledButton;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteSessionButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAEmitterLayer *confettiLayer;

@end

@implementation SessionDetailsViewController

PFUser *me;
BOOL isPartOfSession;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    me = [[PFUser currentUser] fetchIfNeeded];
    
    isPartOfSession = NO;
    [Helpers setCornerRadiusAndColorForButton:self.addMyselfButton andIsSmall:NO];
    [Helpers setCornerRadiusAndColorForButton:self.inviteFriendButton andIsSmall:NO];
    
    [self disableAddButton];
    [self toggleDeleteSessionButton];
    [self initializeDetails];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    self.collectionView.layer.cornerRadius = [Constants buttonCornerRadius];
    
    [self.collectionView reloadData];
}

#pragma mark - UI Configuration

- (void)disableInviteButton {
    self.inviteFriendButton.alpha = 0;
    [self.inviteFriendButton setEnabled:NO];
}

- (void)enableInviteButton {
    if (![self.sessionDetails.occupied isEqualToNumber:self.sessionDetails.capacity]) {
        self.inviteFriendButton.alpha = 1;
        [self.inviteFriendButton setEnabled:YES];
    }
}

- (void)disableAddButton {
    self.disabledButton.alpha = 0;
    for (PFUser *user in self.sessionDetails.playersList) {
        [user fetchIfNeeded];
        if ([me.username isEqualToString:user.username]) {
            [self changeAddButtonToLeave];
            if ([self.sessionDetails.occupied isEqual:self.sessionDetails.capacity]) {
                self.inviteFriendButton.alpha = 0;
                [self.inviteFriendButton setEnabled:NO];
            }
            return;
        }
    }
    if ([self.sessionDetails.occupied isEqual:self.sessionDetails.capacity]) {
        self.disabledButton.text = [Strings fullSessionErrorMsg];
        self.disabledButton.textColor = [UIColor redColor];
        [self.addMyselfButton setEnabled:NO];
        isPartOfSession = NO;
        self.addMyselfButton.alpha = 0;
        self.disabledButton.alpha = 1;
        self.inviteFriendButton.alpha = 0;
    }
    [self disableInviteButton];
}

- (void)changeAddButtonToLeave {
    isPartOfSession = YES;
    [self.addMyselfButton setTitle:@"Leave Session" forState:UIControlStateNormal];
}

- (void)changeAddButtonToJoin {
    isPartOfSession = NO;
    [self disableInviteButton];
    [self.addMyselfButton setTitle:@"Join Session" forState:UIControlStateNormal];
}

- (void)toggleDeleteSessionButton {
    PFUser *creator = [self.sessionDetails[@"creator"] fetchIfNeeded];
    const BOOL isOwnerOfSession = [creator.objectId isEqualToString:me.objectId];
    if (isOwnerOfSession) {
        [self.deleteSessionButton setEnabled:YES];
        self.deleteSessionButton.alpha = 1;
    } else {
        [self.deleteSessionButton setEnabled:NO];
        self.deleteSessionButton.alpha = 0;
    }
}

- (void)initializeDetails {
    self.sportLabel.text = self.sessionDetails.sport;
    [self initializeCapacityString];
    self.levelLabel.text = self.sessionDetails.skillLevel;
    Location *loc = [self.sessionDetails.location fetchIfNeeded];
    self.locationLabel.text = loc.locationName;
    self.dateTimeLabel.text = [Helpers getTimeGivenDurationForSession:self.sessionDetails];
    self.createdDateLabel.text = [@"Session created at: " stringByAppendingString:[Helpers formatDate:self.sessionDetails.updatedAt]];
}

- (void)initializeCapacityString {
    const BOOL sessionIsFull = [self.sessionDetails.capacity isEqual:self.sessionDetails.occupied];
    self.capacityLabel.text = sessionIsFull ? [Strings noOpenSlotsErrorMsg]
                                            : [Helpers capacityString:self.sessionDetails.occupied
                                                         with:self.sessionDetails.capacity];
}

- (IBAction)deleteSession:(id)sender {
    NSString *sessionId = self.sessionDetails.objectId;
    [ManageUserStatistics removeSession:sessionId
                                ofSport:self.sessionDetails.sport
                               fromUser:me];
    [NotificationHandler unscheduleSessionNotification:sessionId];
    [self.sessionDetails deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self returnToHomeButStay:NO];
    }];
}

- (void)returnToHomeButStay:(BOOL)stay {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *homeVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    HomeViewController *vc = [[homeVC viewControllers][0] childViewControllers][0];
    self.delegate = (id)vc;
    [self.delegate reloadHomeTabSessions];
    if (!stay) {
        self.view.window.rootViewController = homeVC;
    }
}

- (IBAction)goToLocation:(id)sender {
    [APIManager goToAddress:self.sessionDetails.location onPlatform:@"Google"];
}

#pragma mark - Animating confetti

- (void)showConfetti {
    [self stopConfetti];
    
    self.confettiLayer = [CAEmitterLayer layer];
    self.confettiLayer.emitterPosition = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.origin.y);
    self.confettiLayer.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
    
    NSArray *colors = [Constants listOfSystemColors];
    
    NSMutableArray *cells = [NSMutableArray arrayWithCapacity:colors.count];
    
    [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.scale = 0.1;
        cell.emissionRange = M_PI * 2;
        cell.lifetime = 5.0;
        cell.birthRate = 20;
        cell.velocity = 200;
        cell.xAcceleration = -20;
        cell.yAcceleration = -20;
        cell.zAcceleration = -20;
        cell.color = [color CGColor];
        cell.contents = (id)[[UIImage imageNamed:@"confetti"] CGImage];
        [cells addObject:cell];
    }];
        
    self.confettiLayer.emitterCells = (NSArray *)cells;
    [self.view.layer addSublayer:self.confettiLayer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(stopConfetti) userInfo:nil repeats:NO];
}

- (void)stopConfetti {
    [self.confettiLayer removeFromSuperlayer];
}

#pragma mark - Add to session button action

- (IBAction)addMyself:(id)sender {
    NSString *sessionObjectId = self.sessionDetails.objectId;
    if (isPartOfSession) {
        [self stopConfetti];
        // For leaving session
        
        [self updateLeaveUi];
        [self changeAddButtonToJoin];
        [self disableInviteButton];
        
        PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
        Session *session = [query getObjectWithId:self.sessionDetails.objectId];

        NSMutableArray *oldPlayersList = (NSMutableArray *)session[@"playersList"];
        
        PFUser * _Nullable userToRemove = nil;
        for (PFUser *user in oldPlayersList) {
            if ([user.objectId isEqualToString:me.objectId]) {
                userToRemove = user;
                break;
            }
        }
        
        [oldPlayersList removeObject:userToRemove];
                    
        session[@"playersList"] = (NSArray *)oldPlayersList;
        
        int newOccupied = (int)oldPlayersList.count;
        session[@"occupied"] = [NSNumber numberWithInt:newOccupied];
        
        [self saveSession:session];
        
        // Remove this session from user's history
        [ManageUserStatistics updateDictionaryRemoveSession:sessionObjectId
                                                   forSport:self.sessionDetails.sport
                                                    andUser:me];
        
        // Unschedule notification for this session
        [NotificationHandler unscheduleSessionNotification:sessionObjectId];
    } else {
        // For joining session
        [self updateJoinUI];
        [self showConfetti];
        [self changeAddButtonToLeave];
        [self enableInviteButton];
        
        PFQuery *query = [PFQuery queryWithClassName:@"SportsSession"];
        Session *session = [query getObjectWithId:self.sessionDetails.objectId];

        NSMutableArray *oldPlayersList = (NSMutableArray *)session[@"playersList"];
        [oldPlayersList addObject:me];
        
        session[@"playersList"] = (NSArray *)oldPlayersList;
        
        int newOccupied = (int)oldPlayersList.count;
        session[@"occupied"] = [NSNumber numberWithInt:newOccupied];
        
        [self saveSession:session];
        
        // Add this session to user's history
        [ManageUserStatistics updateDictionaryAddSession:sessionObjectId
                                                forSport:self.sessionDetails.sport
                                                 andUser:me];
        
        // Schedule notification for this user
        [NotificationHandler scheduleSessionNotification:sessionObjectId];
        
        // Run recommendation system
        [RecommendationData runRecommenderSystemJustTookQuiz:NO];
    }
}

- (void)saveSession:(Session *)session {
    [session saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [self returnToHomeButStay:YES];
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

- (void)updateJoinUI {
    // Update player profile list
    NSMutableArray *oldPlayersList = (NSMutableArray *)self.sessionDetails.playersList;
    [oldPlayersList addObject:me];
    self.sessionDetails.playersList = (NSArray *)oldPlayersList;
    [self.collectionView reloadData];
    
    // Update player count / number of open slots
    int newOccupied = (int)oldPlayersList.count;
    self.sessionDetails.occupied = [NSNumber numberWithInt:newOccupied];
    [self initializeCapacityString];
}

- (void)updateLeaveUi {
    // Update player profile list
    NSMutableArray *oldPlayersList = (NSMutableArray *)self.sessionDetails.playersList;
    
    PFUser * _Nullable userToRemove = nil;
    for (PFUser *user in oldPlayersList) {
        if ([user.objectId isEqualToString:me.objectId]) {
            userToRemove = user;
            break;
        }
    }
    [oldPlayersList removeObject:userToRemove];
    self.sessionDetails.playersList = (NSArray *)oldPlayersList;
    [self.collectionView reloadData];
    
    // Update player count / number of open slots
    int newOccupied = (int)oldPlayersList.count;
    self.sessionDetails.occupied = [NSNumber numberWithInt:newOccupied];
    [self initializeCapacityString];
}

- (void)resetButtonColor {
    [self.inviteFriendButton setBackgroundColor:[Constants playmateBlue]];
}

#pragma mark - Collection view protocol methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sessionDetails.playersList.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PlayerProfileCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayerProfileCollectionCell" forIndexPath:indexPath];
    
    // Instead of indexPath.row, using this to reverse player list
    // to display most recently joined member first in collection view
    cell.userProfile = self.sessionDetails.playersList[self.sessionDetails.playersList.count-indexPath.row-1];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - Empty collection view protocol methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants smallPlaymateLogo];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = [Strings emptyPlayerProfilesPlaceholderTitle];
    return [[NSAttributedString alloc] initWithString:text attributes:[Constants titleAttributes]];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [Constants playmateBlue];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isMemberOfClass:[PlayerProfileCollectionCell class]]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        PFUser* data = self.sessionDetails.playersList[self.sessionDetails.playersList.count-indexPath.row-1];
        PlayerProfileViewController *vc = [segue destinationViewController];
        vc.user = data;
    } else if ([segue.identifier isEqualToString:@"sessionDetailsInvite"]) {
        [self.inviteFriendButton setBackgroundColor:[Constants playmateBlueSelected]];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resetButtonColor) userInfo:nil repeats:NO];
        FriendsListViewController *vc = [segue destinationViewController];
        vc.isForInvitations = YES;
        vc.sessionWithInvite = self.sessionDetails.objectId;
        vc.thisUser = [[PFUser currentUser] fetchIfNeeded];
    }
}

@end
