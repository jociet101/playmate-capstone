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
    
    self.sportLabel.text = [self.session.sport stringByAppendingString:[Helpers makePlayerStringForSession:self.session withWith:YES]];
    
    Location *loc = [self.session.location fetchIfNeeded];
    
    self.locationLabel.text = loc.locationName;
    
    const BOOL sessionIsFull = [self.session.capacity isEqual:self.session.occupied];
    NSString *capacityString = sessionIsFull ? [Strings noOpenSlotsErrorMsg]
                                             : [Helpers capacityString:self.session.occupied
                                                          with:self.session.capacity];
    
    self.levelCapacityLabel.text = [self.session.skillLevel stringByAppendingString:[@", " stringByAppendingString:capacityString]];
    
    self.dateTimeLabel.text = [Helpers getTimeGivenDurationForSession:self.session];
}

@end
