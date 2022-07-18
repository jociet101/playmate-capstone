//
//  SessionCollectionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import "SessionCollectionCell.h"
#import "Constants.h"
#import "Helpers.h"
#import "Location.h"

@interface SessionCollectionCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerListLabel;

@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;

@end

BOOL viewingFront;

@implementation SessionCollectionCell

- (void)setSession:(Session *)session {
    [self setUpDoubleTapGesture];
    
    self.layer.cornerRadius = [Constants buttonCornerRadius];
    
    _session = session;
    
    self.sportLabel.text = self.session.sport;

    NSString *playersString = @"";
    BOOL firstPerson = YES;
    
    for (PFUser *player in self.session.playersList) {
        [player fetchIfNeeded];

        NSString *playerName = player[@"firstName"][0];
        
        if (firstPerson) {
            playersString = [playersString stringByAppendingString:playerName];
            firstPerson = NO;
        } else {
            playersString = [playersString stringByAppendingString:[@", " stringByAppendingString:playerName]];
        }
    }
    
    self.playerListLabel.text = playersString;
    
    Location *loc = [self.session.location fetchIfNeeded];
    
    self.locationLabel.text = loc.locationName;
    
    const BOOL sessionIsFull = [self.session.capacity isEqual:self.session.occupied];
    NSString *capacityString = sessionIsFull ? [Constants noOpenSlotsErrorMsg]
                                             : [Constants capacityString:self.session.occupied
                                                          with:self.session.capacity];
    
    self.skillLevelLabel.text = [self.session.skillLevel stringByAppendingString:[@", " stringByAppendingString:capacityString]];
    
    self.dateLabel.text = [Helpers getTimeGivenDurationForSession:self.session];
    
    [self viewFront];
}

- (void)viewFront {
    viewingFront = YES;
    
    self.sportLabel.alpha = 1;
    self.dateLabel.alpha = 1;
    
    self.locationLabel.alpha = 0;
    self.skillLevelLabel.alpha = 0;
    self.playerListLabel.alpha = 0;
}

- (void)viewBack {
    viewingFront = NO;
    
    self.sportLabel.alpha = 0;
    self.dateLabel.alpha = 0;
    
    self.locationLabel.alpha = 1;
    self.skillLevelLabel.alpha = 1;
    self.playerListLabel.alpha = 1;
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
    if (viewingFront) {
        [self viewBack];
    } else {
        [self viewFront];
    }
}

@end
