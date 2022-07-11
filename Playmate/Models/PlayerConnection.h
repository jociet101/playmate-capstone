//
//  PlayerConnection.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/11/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayerConnection : PFObject<PFSubclassing>

@property (nonatomic, strong) NSString *userObjectId;
@property (nonatomic, strong) NSDictionary *connections;

+ (void)savePlayerConnection:(PlayerConnection *)connection;

@end

NS_ASSUME_NONNULL_END
