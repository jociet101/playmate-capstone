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
    
    self.sportLabel.text = self.session.sport;
}

@end
