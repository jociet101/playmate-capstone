//
//  Strings.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/25/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Strings : NSObject

#pragma mark - API Endpoints
+ (NSString *)geoapifyBaseURLString;
+ (NSString *)decathalonSportsListString;
+ (NSString *)decathalonOneSportString;

#pragma mark - Session Details
// Error messages
+ (NSString *)fullSessionErrorMsg;
+ (NSString *)alreadyInSessionErrorMsg;
+ (NSString *)noOpenSlotsErrorMsg;
// Date format
+ (NSString *)dateFormatString;

#pragma mark - Filters

+ (NSString *)selectLocationPlease;
+ (NSString *)selectDurationPlease;
+ (NSString *)selectSportPlease;
+ (NSString *)selectDateTimePlease;
+ (NSString *)selectSkillLevelPlease;
+ (NSString *)selectNumberOfPlayersPlease;

#pragma mark - Empty Table or Collection View Messages
+ (NSString *)emptyTablePlaceholderMsg;
+ (NSString *)emptyTablePlaceholderTitle;
+ (NSString *)emptyPlayerProfilesPlaceholderTitle;
+ (NSString *)emptySearchPlaceholderMsg;
+ (NSString *)emptyListPlaceholderMsg;
+ (NSString *)emptyListPlaceholderTitle;
+ (NSString *)emptyIncomingRequestsPlaceholderTitle;
+ (NSString *)emptyOutgoingRequestsPlaceholderTitle;
+ (NSString *)emptyCollectionLoadingSessionsTitle;
+ (NSString *)emptyInvitationsPlaceholderTitle;
+ (NSString *)emptyInvitationsPlaceholderMsg;

@end

NS_ASSUME_NONNULL_END
