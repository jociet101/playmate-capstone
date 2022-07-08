//
//  SessionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionCell.h"
#import "Constants.h"

@interface SessionCell ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelCapacityLabel;

@end

@implementation SessionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSession:(Session *)session {
    _session = session;
    
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
    
    self.sportLabel.text = [self.session.sport stringByAppendingString:[@" w/ " stringByAppendingString:playersString]];
    
    Location *loc = self.session.location;
    [loc fetchIfNeeded];
    
    self.locationLabel.text = loc.locationName;
    
    // Form the fraction into a string
    NSString *capacityString = [Constants capacityString:self.session.occupied with:self.session.capacity];

    if ([self.session.capacity isEqual:self.session.occupied]) {
        capacityString = [Constants noOpenSlotsErrorMsg];
    }
    
    self.levelCapacityLabel.text = [self.session.skillLevel stringByAppendingString:[@", " stringByAppendingString:capacityString]];
        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Constants dateFormatString];
    NSString *originalDate = [formatter stringFromDate:self.session.occursAt];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    self.dateTimeLabel.text = [formatter stringFromDate:date];
}

@end
