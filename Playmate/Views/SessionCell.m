//
//  SessionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionCell.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

@interface SessionCell ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelCapacityLabel;

@end

@implementation SessionCell

- (void)setSession:(Session *)session {
    self.backgroundColor = [Constants playmateBlue];
    
    _session = session;
    
    NSString *playersString = @"";
    
    BOOL isFirstPerson = YES;
    
    for (PFUser *player in self.session.playersList) {

        [player fetchIfNeeded];

        NSString *playerName = player[@"firstName"][0];
        
        if (isFirstPerson) {
            playersString = [playersString stringByAppendingString:playerName];
            isFirstPerson = NO;
        } else {
            playersString = [playersString stringByAppendingString:[@", " stringByAppendingString:playerName]];
        }
    }
    
    self.sportLabel.text = (self.session.playersList.count == 0) ? self.session.sport : [self.session.sport stringByAppendingString:[@" w/ " stringByAppendingString:playersString]];
    
    Location *loc = [self.session.location fetchIfNeeded];
    
    self.locationLabel.text = loc.locationName;
    
    const BOOL sessionIsFull = [self.session.capacity isEqual:self.session.occupied];
    NSString *capacityString = sessionIsFull ? [Strings noOpenSlotsErrorMsg]
                                             : [Strings capacityString:self.session.occupied
                                                          with:self.session.capacity];
    
    self.levelCapacityLabel.text = [self.session.skillLevel stringByAppendingString:[@", " stringByAppendingString:capacityString]];
    
    self.dateTimeLabel.text = [Helpers getTimeGivenDurationForSession:self.session];
}

@end
