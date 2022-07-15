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
#import <QuartzCore/QuartzCore.h>
#import "Helpers.h"

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

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAEmitterLayer *confettiLayer;

@end

@implementation SessionDetailsViewController

PFUser *me;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    me = [[PFUser currentUser] fetchIfNeeded];

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
- (void)immediatelyDisableAddButton {
    self.disabledButton.text = [Constants alreadyInSessionErrorMsg];
    self.disabledButton.textColor = [UIColor redColor];
    [self.addMyselfButton setEnabled:NO];
    self.addMyselfButton.alpha = 0;
}

- (void)initializeDetails {
    self.sportLabel.text = self.sessionDetails.sport;
    
    const BOOL sessionIsFull = [self.sessionDetails.capacity isEqual:self.sessionDetails.occupied];
    self.capacityLabel.text = sessionIsFull ? [Constants noOpenSlotsErrorMsg]
                                            : [Constants capacityString:self.sessionDetails.occupied
                                                         with:self.sessionDetails.capacity];
    
    self.levelLabel.text = self.sessionDetails.skillLevel;
    
    Location *loc = [self.sessionDetails.location fetchIfNeeded];
    
    self.locationLabel.text = loc.locationName;
    
    self.dateTimeLabel.text = [Helpers getTimeGivenDurationForSession:self.sessionDetails];
    
    self.createdDateLabel.text = [@"Session created at: " stringByAppendingString:[Constants formatDate:self.sessionDetails.updatedAt]];
}

#pragma mark - Animating confetti

- (void)showConfetti {
    
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
    [self showConfetti];
    [self immediatelyDisableAddButton];
    
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
        PlayerProfileViewController *vc = [segue destinationViewController];
        vc.user = data;
    }
}

@end
