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

@interface SessionCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerListLabel;

@end

@implementation SessionCollectionCell

- (void)setSession:(Session *)session {
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
}

@end
