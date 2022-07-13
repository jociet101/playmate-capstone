//
//  OutgoingRequestCell.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/13/22.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutgoingRequestCell : UITableViewCell

@property (nonatomic, strong) NSString *userObjectId;

- (void)setUserObjectId:(NSString *)userObjectId;

@end

NS_ASSUME_NONNULL_END
