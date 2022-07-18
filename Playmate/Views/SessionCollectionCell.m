//
//  SessionCollectionCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/18/22.
//

#import "SessionCollectionCell.h"

@interface SessionCollectionCell ()

@property (weak, nonatomic) IBOutlet UILabel *sportLabel;

@end

@implementation SessionCollectionCell

- (void)setSession:(Session *)session {
    _session = session;
    
    self.sportLabel.text = session.sport;
}

@end
