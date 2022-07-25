//
//  InvitationCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/22/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Invitation.h"
#import "Session.h"

NS_ASSUME_NONNULL_BEGIN

@protocol InvitationCellDelegate

- (void)viewSessionFromInvite:(Session *)session;

@end

@interface InvitationCell : UITableViewCell

@property (nonatomic, strong) Invitation *invitation;
@property (nonatomic, strong) id<InvitationCellDelegate> delegate;

- (void)setInvitation:(Invitation *)invitation;

@end

NS_ASSUME_NONNULL_END
