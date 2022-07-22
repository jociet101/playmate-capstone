//
//  InvitationCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/22/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Invitation.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvitationCell : UITableViewCell

@property (nonatomic, strong) Invitation *invitation;

- (void)setInvitation:(Invitation *)invitation;

@end

NS_ASSUME_NONNULL_END
