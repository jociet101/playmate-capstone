//
//  SessionCollectionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import "SessionCollectionCell.h"
#import "Location.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface SessionCollectionCell () <UIGestureRecognizerDelegate>

// Front labels
@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet UILabel *sportFrontLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateFrontLabel;

// Back labels
@property (weak, nonatomic) IBOutlet UILabel *sportBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerListLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewFullSessionDetailsButton;

// Double tap gesture
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (weak, nonatomic) IBOutlet UILabel *doubleTapLabel;

@end

// Used to toggle whether to display front or back of card
BOOL isViewingFront;

@implementation SessionCollectionCell

- (void)setSession:(Session *)session {
    [self setUpDoubleTapGesture];
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    self.viewFullSessionDetailsButton.layer.cornerRadius = [Constants smallButtonCornerRadius];
    
    self.backgroundColor = [Constants playmateBlue];
    
    _session = session;
    
    self.sportFrontLabel.text = self.session.sport;
    self.sportBackLabel.text = self.session.sport;
    
    self.playerListLabel.text = [@"Players: " stringByAppendingString:[Helpers makePlayerStringForSession:self.session withWith:NO]];
    
    Location *loc = [self.session.location fetchIfNeeded];
    self.locationLabel.text = [@"Location: " stringByAppendingString:loc.locationName];
    
    self.skillLevelLabel.text = [@"Skill Level: " stringByAppendingString:self.session.skillLevel];
    
//    self.dateFrontLabel.text = [Helpers getTimeGivenDurationForSession:self.session];
    self.dateFrontLabel.text = [Helpers getTimeFromNowUntil:self.session.occursAt];
    self.dateBackLabel.text = [Helpers getTimeGivenDurationForSession:self.session];
    
    [self.frontImageView setImage:[Helpers resizeImage:[UIImage imageNamed:[Constants getImageNameForSport:self.session.sport]] withDimension:208]];

    [self viewFront];
}

- (void)viewFront {
    isViewingFront = YES;
    
    self.frontImageView.alpha = 1;
    self.sportFrontLabel.alpha = 1;
    self.dateFrontLabel.alpha = 1;
    
    self.sportBackLabel.alpha = 0;
    self.dateBackLabel.alpha = 0;
    self.locationLabel.alpha = 0;
    self.skillLevelLabel.alpha = 0;
    self.playerListLabel.alpha = 0;
    self.viewFullSessionDetailsButton.alpha = 0;
    [self.viewFullSessionDetailsButton setEnabled:NO];

    self.doubleTapLabel.text = [Strings doubleTapInstructionFront];
}

- (void)viewBack {
    isViewingFront = NO;
    
    self.frontImageView.alpha = 0;
    self.sportFrontLabel.alpha = 0;
    self.dateFrontLabel.alpha = 0;
    
    self.sportBackLabel.alpha = 1;
    self.dateBackLabel.alpha = 1;
    self.locationLabel.alpha = 1;
    self.skillLevelLabel.alpha = 1;
    self.playerListLabel.alpha = 1;
    self.viewFullSessionDetailsButton.alpha = 1;
    [self.viewFullSessionDetailsButton setEnabled:YES];
    
    self.doubleTapLabel.text = [Strings doubleTapInstructionBack];
}

- (void)setUpDoubleTapGesture {
    // gesture recognizer set up
    self.contentView.userInteractionEnabled = YES;
    self.doubleTapGesture = [[UITapGestureRecognizer alloc] init];
    [self.doubleTapGesture addTarget:self action:@selector(didDoubleTapCell:)];
    self.doubleTapGesture.delegate = self;
    [self.doubleTapGesture setNumberOfTapsRequired:2];
    [self.contentView addGestureRecognizer:self.doubleTapGesture];
}

- (void)didDoubleTapCell:(id)sender {
    if (isViewingFront) {
        [self viewBack];
    } else {
        [self viewFront];
    }
}

- (IBAction)didTapFullSessionDetails:(id)sender {
    [self.delegate segueToFullSessionDetails:self.session];
}

@end
