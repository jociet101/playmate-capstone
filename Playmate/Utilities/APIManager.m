//
//  APIManager.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import "APIManager.h"
#import "UIKit/UIKit.h"
#import "AFHTTPSessionManager.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"

static NSString * geoapify;

@interface APIManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation APIManager

- (id)init {
    self = [super init];

    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];

    NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

    geoapify = [dict objectForKey: @"geoapify_key"];
    
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"geoapify_key"]) {
        geoapify = [[NSUserDefaults standardUserDefaults] stringForKey:@"geoapify_key"];
    }
    
    return self;
}

- (void)getSportsListWithCompletion:(void(^)(NSDictionary *list, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[Strings decathalonSportsListString]  parameters:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *list) {
        completion(list, nil);
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        completion(nil, error);
    }];
}

- (void)getSportWithId:(NSString *)sportId withCompletion:(void(^)(NSDictionary *sportData, NSError *error))completion {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [[Strings decathalonOneSportString] stringByAppendingString:sportId];
    [manager GET:url  parameters:nil progress:nil success:^(NSURLSessionDataTask * task, NSDictionary *sportData) {
        completion(sportData, nil);
    } failure:^(NSURLSessionDataTask * task, NSError *error) {
        [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        completion(nil, error);
    }];
}

- (void)getGeocodedLocation:(NSString *)address withCompletion:(void(^)(Location *loc, NSError *error))completion {
    // Parse the address into array then into format needed for url
    NSArray *addyComponents = [address componentsSeparatedByString:@" "];
    NSString *craftedLink = @"";
    
    BOOL isFirstComponent = YES;
    for (NSString *component in addyComponents) {
        if (isFirstComponent) {
            isFirstComponent = NO;
            craftedLink = [craftedLink stringByAppendingString:component];
        }
        else {
            craftedLink = [craftedLink stringByAppendingString:@"%"];
            craftedLink = [craftedLink stringByAppendingFormat:@"20%@", component];
        }
    }
    
    NSString *queryString = [Helpers geoapifyGeocodingURLWithKey:geoapify andCraftedLink:craftedLink];
    NSURL *url = [NSURL URLWithString:queryString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // parse dictionary
            NSArray *results = dataDictionary[@"results"];
            
            if (results.count == 0) {
                completion(nil, nil);
            }
            else {
                NSDictionary *firstResult = results[0];
                
                Location *loc = [Location new];
                loc.lat = [NSNumber numberWithDouble:[firstResult[@"lat"] doubleValue]];
                loc.lng = [NSNumber numberWithDouble:[firstResult[@"lon"] doubleValue]];
                loc.locationName = firstResult[@"formatted"];
                
                completion(loc, nil);
            }
        }
    }];
    [task resume];
}

- (void)getReverseGeocodedLocation:(Location *)location withCompletion:(void(^)(NSString *name, NSError *error))completion {
    
    // Parse the location then into format needed for url
    NSString *longitudeString = [NSString stringWithFormat:@"%f", [location.lng doubleValue]];
    NSString *latitudeString = [NSString stringWithFormat:@"%f", [location.lat doubleValue]];
    
    NSString *queryString = [Helpers geoapifyReverseGeocodingURLWithKey:geoapify andLongitutde:longitudeString andLatitude:latitudeString];
    NSURL *url = [NSURL URLWithString:queryString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            // parse dictionary
            NSDictionary *result = dataDictionary[@"features"][0][@"properties"];
            completion(result[@"formatted"], nil);
        }
    }];
    [task resume];
}

// Apple Maps Link
+ (void)goToAddress:(Location *)location onPlatform:(NSString *)platform {
    [location fetchIfNeeded];
    NSString *mapURL = @"http://maps.apple.com/?address=";
    
    if ([platform isEqualToString:@"Google"]) {
        mapURL = @"https://www.google.com/maps/place/";
    }
    
    // Parse the address into array then into format needed for url
    NSArray *addressComponents = [location.locationName componentsSeparatedByString:@" "];
    NSString *craftedLink = @"";
    
    BOOL isFirstComponent = YES;
    for (NSString *component in addressComponents) {
        if (isFirstComponent) {
            isFirstComponent = NO;
            craftedLink = [craftedLink stringByAppendingString:component];
        } else {
            craftedLink = [craftedLink stringByAppendingFormat:@"+%@", component];
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", mapURL, craftedLink];
    NSURL *url = [NSURL URLWithString:urlString];
    const BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];

    if (canOpen) {
        [[UIApplication sharedApplication] openURL:url
                                           options:@{}
                                 completionHandler:^(BOOL success) {}];
    } else {
        [Helpers handleAlert:nil
                   withTitle:@"Cannot find location"
                 withMessage:[NSString stringWithFormat:@"Address %@ cannot be found on maps.", location.locationName]
           forViewController:self];
    }
}

@end
