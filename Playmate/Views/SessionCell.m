//
//  SessionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/5/22.
//

#import "SessionCell.h"

@interface SessionCell ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;

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
    NSLog(@"set session called");
    
    _session = session;
    
    NSString *playersString = @"";
    
    BOOL firstPerson = YES;
    
    for (PFUser *player in self.session.playersList) {

        [player fetchIfNeeded];

        NSString *playerName = player[@"firstName"][0];
        
        if (firstPerson) {
            playersString = [playersString stringByAppendingString:playerName];
        } else {
            playersString = [playersString stringByAppendingString:[@", " stringByAppendingString:playerName]];
        }

    }
    
    self.sportLabel.text = [self.session.sport stringByAppendingString:[@" w/ " stringByAppendingString:playersString]];
}

@end
