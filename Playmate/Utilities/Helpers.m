//
//  Helpers.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import "Helpers.h"
#import "Constants.h"
#import "Strings.h"
#import "DateTools.h"

@implementation Helpers

#pragma mark - Parse Related

+ (PlayerConnection *)getPlayerConnectionForUser:(PFUser *)user {
    return [user[@"playerConnection"][0] fetchIfNeeded];
}

#pragma mark - API Endpoints

+ (NSString *)geoapifyGeocodingURLWithKey:(NSString *)geoapify andCraftedLink:(NSString *)craftedLink {
    return [NSString stringWithFormat:@"%@/geocode/search?text=%@&format=json&apiKey=%@", [Strings geoapifyBaseURLString], craftedLink, geoapify];
}

+ (NSString *)geoapifyReverseGeocodingURLWithKey:(NSString *)geoapify andLongitutde:(NSString *)longitutde andLatitude:(NSString *)latitude {
    return [NSString stringWithFormat:@"%@/geocode/reverse?lat=%@&lon=%@&apiKey=%@", [Strings geoapifyBaseURLString], latitude, longitutde, geoapify];
}

#pragma mark - Handling Alerts

+ (void)handleAlert:(NSError * _Nullable)error
          withTitle:(NSString *)title
        withMessage:(NSString * _Nullable)message
  forViewController:(id)viewController {
    if (error != nil) {
        message = error.localizedDescription;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [viewController viewDidLoad];
    }];
    
    [alertController addAction:okAction];
    [viewController presentViewController:alertController animated: YES completion: nil];
}

#pragma mark - Button UI

+ (void)setCornerRadiusAndColorForButton:(UIButton *)button andIsSmall:(BOOL)isSmall {
    button.layer.cornerRadius = isSmall ? [Constants smallButtonCornerRadius] : [Constants buttonCornerRadius];
    [button setBackgroundColor:[Constants playmateBlue]];
}

#pragma mark - Image Manipulation

// Helper for rotating image
+ (CGFloat)degreesToRadians:(CGFloat)degrees {
    return M_PI * degrees / 180;
}

// Rotates image by degrees given image and degrees
+ (UIImage *)image:(UIImage *)image rotatedByDegrees:(CGFloat)degrees {
    CGFloat radians = [Helpers degreesToRadians:degrees];

    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, image.size.width, image.size.height)];
    rotatedViewBox.transform = CGAffineTransformMakeRotation(radians);
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, [[UIScreen mainScreen] scale]);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);

    CGContextRotateCTM(bitmap, radians);

    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2 , image.size.width, image.size.height), image.CGImage );

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

// Resize image to square of dimension given
+ (UIImage *)resizeImage:(UIImage *)image withDimension:(int)dimension {
    CGSize size = CGSizeMake(dimension, dimension);
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dimension, dimension)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (void)roundCornersOfImage:(UIImageView *)image {
    image.layer.cornerRadius = image.frame.size.width/2.0f;
}

#pragma mark - Dates

+ (NSString *)formatDate:(NSDate *)original {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Strings dateFormatString];
    NSString *originalDate = [formatter stringFromDate:original];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:date];
}

+ (NSString *)formatDateShort:(NSDate *)original {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Strings dateFormatString];
    NSString *originalDate = [formatter stringFromDate:original];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    return [formatter stringFromDate:date];
}

+ (NSString *)formatDateNoTime:(NSDate *)original {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Strings dateFormatString];
    NSString *originalDate = [formatter stringFromDate:original];
    
    NSDate *date = [formatter dateFromString:originalDate];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    
    return [formatter stringFromDate:date];
}

+ (NSString *)appendAgoToTime:(NSDate *)timeAgo {
    return [[timeAgo shortTimeAgoSinceNow] stringByAppendingString:@" ago"];
}

+ (NSDate *)removeMinutes:(int)minutes fromTime:(NSDate *)time {
    return [time dateByAddingMinutes:-minutes];
}

+ (NSDateComponents *)getComponentsFromDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    int unitFlags = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute );
    NSDateComponents *dateComponents =
                        [gregorian components:unitFlags
                                     fromDate:date];
    return dateComponents;
}

+ (NSString *)getTimeFromNowUntil:(NSDate *)date {
    // total seconds between
    long interval = (long)[date timeIntervalSinceDate:[NSDate now]];
    long days = interval / (60 * 60 * 24);
    interval = interval % (60 * 60 * 24);
    long hours = interval / (60 * 60);
    interval = interval % (60 * 60);
    long minutes = interval / 60;
    
    return [NSString stringWithFormat:@"Session in %ld days, %ld hours, %ld minutes", days, hours, minutes];
}

#pragma mark - Profile Tab and Friend Notifications

+ (NSString *)concatenateFirstName:(NSString *)first andLast:(NSString *)last {
    return [first stringByAppendingString:[@" " stringByAppendingString:last]];
}

+ (NSString *)getAgeInYears:(NSDate *)date {
    NSString *rawYears = [date timeAgoSinceNow];
    NSArray *parsed = [rawYears componentsSeparatedByString:@" "];
    NSString *year = parsed[0];
    return year;
}

+ (NSString *)outgoingRequestMessageFor:(PFUser *)user {
    NSString *name = [Helpers concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    return [@"You requested to be friends with " stringByAppendingString:name];
}

+ (NSString *)incomingRequestMessageFor:(PFUser *)user {
    NSString *requesterName = [Helpers concatenateFirstName:user[@"firstName"][0] andLast:user[@"lastName"][0]];
    return [requesterName stringByAppendingString:@" wants to be friends."];
}

#pragma mark - Miscellaneous Helper Methods

// Given a list of players that are PFUsers, returns set of object id strings for those players
+ (NSMutableSet *)getPlayerObjectIdSet:(NSArray *)playerList {
    NSMutableSet *playersSet = [[NSMutableSet alloc] init];
    [playerList enumerateObjectsUsingBlock:^(PFUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
        [playersSet addObject:user.objectId];
    }];
    return playersSet;
}

// Returns number of days between two dates
+ (NSString *)getTimeGivenDurationForSession:(Session *)session {
    NSDate *startTime = session.occursAt;
    NSDate *endTime = [startTime dateByAddingMinutes:60*[session.duration floatValue]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Strings dateFormatString];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSString *dateString = [formatter stringFromDate:startTime];
    
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *startTimeString = [formatter stringFromDate:startTime];
    NSString *endTimeString = [formatter stringFromDate:endTime];
    
    return [dateString stringByAppendingFormat:@", %@ to %@", startTimeString, endTimeString];
}

// Return time string interval for a session given start time and duration
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime {
    NSDate *fromDate;
    NSDate *toDate;

    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
        interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
        interval:NULL forDate:toDateTime];

    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
        fromDate:fromDate toDate:toDate options:0];

    return [difference day];
}

// Return capacity string fraction
+ (NSString *)capacityString:(NSNumber *)occupied with:(NSNumber *)capacity {
    return [[NSString stringWithFormat:@"%d", [capacity intValue] - [occupied intValue]] stringByAppendingString:[@"/" stringByAppendingString:[[NSString stringWithFormat:@"%@", capacity] stringByAppendingString:@" open slots"]]];
}

// String for empty events on given date
+ (NSString *)emptyCalendarTableForDate:(NSDate *)date {
    NSString *dateString = [Helpers formatDateNoTime:date];
    return [@"No sessions on " stringByAppendingString:dateString];
}

// String for details label on player collection cell
+ (NSString *)getDetailsLabelForPlayerCell:(PFUser *)user {
    NSString *genderString = [user[@"gender"][0] isEqualToString:@"Other"] ? @"" : user[@"gender"][0];
    return [[[Helpers getAgeInYears:user[@"birthday"][0]] stringByAppendingString:@" yo "] stringByAppendingString:genderString];
}

// Make players string for session cell
+ (NSString *)makePlayerStringForSession:(Session *)session withWith:(BOOL)with {
    NSString *playersString = @"";
    
    if (session.playersList.count == 0) return playersString;
    
    BOOL isFirstPerson = YES;
    
    for (PFUser *player in session.playersList) {

        [player fetchIfNeeded];

        NSString *playerName = player[@"firstName"][0];
        
        if (isFirstPerson) {
            playersString = [playersString stringByAppendingString:playerName];
            isFirstPerson = NO;
        } else {
            playersString = [playersString stringByAppendingString:[@", " stringByAppendingString:playerName]];
        }
    }
    
    return with ? [@" w/ " stringByAppendingString:playersString] : playersString;
}

// Create notifier label string for home tab
+ (NSString *)getNotifierLabelString {
    long numberRequests = [Helpers numberIncomingFriendRequests];
    long numberInvitations = [Helpers numberIncomingInvitations];
    
    if (numberRequests == 0 && numberInvitations == 0) {
        return @" 🔔 No notifications ";
    }
    NSString *requestsText = (numberRequests == 0) ? @"no" : [NSString stringWithFormat:@"%ld", numberRequests];
    NSString *invitationsText = (numberInvitations == 0) ? @"no" : [NSString stringWithFormat:@"%ld", numberInvitations];
    NSString *requestPlural = (numberRequests == 1) ? @"" : @"s";
    NSString *invitationPlural = (numberInvitations == 1) ? @"" : @"s";
    NSString *notifierText = @" 🔔 You have %@ friend request%@ and %@ invitation%@ → ";
    return [NSString stringWithFormat:notifierText, requestsText, requestPlural, invitationsText, invitationPlural];;
}

+ (long)numberIncomingFriendRequests {
    PFQuery *query = [PFQuery queryWithClassName:@"FriendRequest"];
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    [query whereKey:@"requestToId" equalTo:user.objectId];
    
    NSArray *requests = [query findObjects];
    return requests.count;
}

+ (long)numberIncomingInvitations {
    PFQuery *query = [PFQuery queryWithClassName:@"Invitation"];
    PFUser *user = [[PFUser currentUser] fetchIfNeeded];
    [query whereKey:@"invitationToId" equalTo:user.objectId];

    NSArray *invitations = [query findObjects];
    return invitations.count;
}

// Get greeting
+ (NSString *)getGreetingString {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    NSDate *now = [NSDate now];
    NSString *greeting;
    if ([now hour] >= 17) {
        greeting = @"Good Evening, ";
    } else if ([now hour] >= 12) {
        greeting = @"Good Afternoon, ";
    } else {
        greeting = @"Good Morning, ";
    }
    return [greeting stringByAppendingString:me[@"firstName"][0]];
}

// Get quiz status string
+ (NSString *)getQuizString {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    if ([me objectForKey:@"quizResult"] != nil) {
        return @" 📝 Retake my session preferences quiz → ";
    } else {
        return @" 📝 Take the session preferences quiz! → ";
    }
}

// Get euclidean distance betwen two locations
+ (float)euclideanDistanceBetween:(Location *)location1 and:(Location *)location2 {
    [location1 fetchIfNeeded];
    [location2 fetchIfNeeded];
    
    float latitude1 = [location1.lat floatValue];
    float latitude2 = [location2.lat floatValue];
    float longitude1 = [location1.lng floatValue];
    float longitude2 = [location2.lng floatValue];
    
    float sumSquaredDifferences = pow(latitude1-latitude2, 2) + pow(longitude1-longitude2, 2);
    
    return pow(sumSquaredDifferences, 0.5);
}

#pragma mark - Retrieve Data for Filter/Create Menus

+ (NSArray * _Nullable)getData:(BOOL)needAll forRow:(int)row {
    if (row == 0) {
        return [Constants sportsList:needAll];
    }  else if (row == 2) {
        return [Constants durationList];
    } else if (row == 3) {
        return [Constants skillLevelsList:needAll];
    }
    return nil;
}

+ (NSArray * _Nullable)getFilterData:(BOOL)needAll forRow:(int)row {
    if (row == 0) {
        return [Constants sportsList:needAll];
    } else if (row == 1) {
        return [Constants skillLevelsList:needAll];
    } else if (row == 4) {
        return [Constants sessionTypeList];
    }
    return nil;
}

@end
