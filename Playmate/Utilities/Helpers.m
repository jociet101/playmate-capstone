//
//  Helpers.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import "Helpers.h"
#import "Constants.h"

@implementation Helpers

// For Parse
+ (PlayerConnection *)getPlayerConnectionForUser:(PFUser *)user {
    return [user[@"playerConnection"][0] fetchIfNeeded];
}

// For API endpoints
+ (NSString *)geoapifyGeocodingURLWithKey:(NSString *)geoapify andCraftedLink:(NSString *)craftedLink {
    return [NSString stringWithFormat:@"%@/geocode/search?text=%@&format=json&apiKey=%@", [Constants geoapifyBaseURLString], craftedLink, geoapify];
}

+ (NSString *)geoapifyReverseGeocodingURLWithKey:(NSString *)geoapify andLongitutde:(NSString *)longitutde andLatitude:(NSString *)latitude {
    return [NSString stringWithFormat:@"%@/geocode/reverse?lat=%@&lon=%@&apiKey=%@", [Constants geoapifyBaseURLString], latitude, longitutde, geoapify];
}

// For other stuff
+ (NSMutableSet *)getPlayerObjectIdSet:(NSArray *)playerList {
    NSMutableSet *playersSet = [[NSMutableSet alloc] init];
    [playerList enumerateObjectsUsingBlock:^(PFUser *user, NSUInteger idx, BOOL * _Nonnull stop) {
        [playersSet addObject:user.objectId];
    }];
    return playersSet;
}

// for resizing images
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

+ (NSString *)getTimeGivenDurationForSession:(Session *)session {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *startTime = session.occursAt;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMinute:60*[session.duration intValue]];
    NSDate *endTime = [gregorian dateByAddingComponents:comps toDate:startTime  options:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = [Constants dateFormatString];
    
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterNoStyle;
    NSString *dateString = [formatter stringFromDate:startTime];
    
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    NSString *startTimeString = [formatter stringFromDate:startTime];
    NSString *endTimeString = [formatter stringFromDate:endTime];
    
    return [dateString stringByAppendingFormat:@", %@ to %@", startTimeString, endTimeString];
}

// For handling alerts
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

// For handling dates
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

+ (void)setCornerRadiusAndColorForButton:(UIButton *)button andIsSmall:(BOOL)isSmall {
    button.layer.cornerRadius = isSmall ? [Constants smallButtonCornerRadius] : [Constants buttonCornerRadius];
    [button setBackgroundColor:[Constants playmateBlue]];
}

// For rotating an image

+ (CGFloat)degreesToRadians:(CGFloat)degrees {
    return M_PI * degrees / 180;
}

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

@end
