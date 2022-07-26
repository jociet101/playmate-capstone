//
//  Strings.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/25/22.
//

#import "Strings.h"

@implementation Strings

#pragma mark - API Endpoints

+ (NSString *)geoapifyBaseURLString {
    return @"https://api.geoapify.com/v1/";
}

+ (NSString *)decathalonSportsListString {
    return @"https://sports.api.decathlon.com/sports";
}

+ (NSString *)decathalonOneSportString {
    return @"https://sports.api.decathlon.com/sports/:";
}

#pragma mark - Session Details

+ (NSString *)fullSessionErrorMsg {
    return @"Session is full";
}

+ (NSString *)alreadyInSessionErrorMsg {
    return @"Already in session";
}

+ (NSString *)noOpenSlotsErrorMsg {
    return @"No open slots";
}

+ (NSString *)dateFormatString {
    return @"E MMM d HH:mm:ss yyyy";
}

#pragma mark - Filters

+ (NSString *)selectLocationPlease {
    return @"Please select a location on map.";
}
+ (NSString *)selectDurationPlease {
    return @"Please select a duration.";
}
+ (NSString *)selectSportPlease {
    return @"Please select a sport.";
}
+ (NSString *)selectDateTimePlease {
    return @"Please select a date and time.";
}
+ (NSString *)selectSkillLevelPlease {
    return @"Please select a skill level.";
}
+ (NSString *)selectNumberOfPlayersPlease {
    return @"Please select the number of players.";
}

#pragma mark - Friends and Invitations
+ (NSString *)alreadyInSessionString {
    return @"(Already in session)";
}

+ (NSString *)alreadyInvitedString {
    return @"(Already invited)";
}

#pragma mark - Empty Table or Collection View Messages

+ (NSString *)emptyTablePlaceholderMsg {
    return @"Search for a session to join or create your own session to view them here!";
}

+ (NSString *)emptyTablePlaceholderTitle {
    return @"No Sessions";
}

+ (NSString *)emptyPlayerProfilesPlaceholderTitle {
    return @"No players in this session";
}

+ (NSString *)emptySearchPlaceholderMsg {
    return @"No sessions match your search. Adjust the filters or create your own session!";
}

+ (NSString *)emptyListPlaceholderMsg {
    return @"Explore sessions to meet your Playmates!";
}

+ (NSString *)emptyListPlaceholderTitle {
    return @"No Friends";
}

+ (NSString *)emptyIncomingRequestsPlaceholderTitle {
    return @"No Incoming Friend Requests";
}

+ (NSString *)emptyOutgoingRequestsPlaceholderTitle {
    return @"No Outgoing Friend Requests";
}

+ (NSString *)emptyCollectionLoadingSessionsTitle {
    return @"Loading Sessions ...";
}

+ (NSString *)emptyInvitationsPlaceholderTitle {
    return @"No invitations";
}

+ (NSString *)emptyInvitationsPlaceholderMsg {
    return @"Check back later to see if your friends invited you to join their session!";
}

#pragma mark - Other Strings

+ (NSString *)defaultAll {
    return @"All";
}

+ (NSString *)radiusPlaceholder {
    return @"10 (default)";
}

+ (NSString *)doubleTapInstructionFront {
    return @"Double Tap for Details";
}

+ (NSString *)doubleTapInstructionBack {
    return @"Double Tap to Return";
}

+ (NSString *)errorString {
    return @"Error";
}

@end
