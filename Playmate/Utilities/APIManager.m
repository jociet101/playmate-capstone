//
//  APIManager.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/7/22.
//

#import "APIManager.h"
#import "UIKit/UIKit.h"

static NSString * const geoapifyBaseURLString = @"https://api.geoapify.com/v1/";
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

- (void)getGeocodedLocation:(NSString *)address WithCompletion:(void(^)(Location *loc, NSError *error))completion {
    
    // Parse the address into array then into format needed for url
    NSArray *addyComponenets = [address componentsSeparatedByString:@" "];
    NSString *craftedLink = @"";
    
    BOOL firstComp = YES;
    
    for (NSString *component in addyComponenets) {
        if (firstComp) {
            firstComp = NO;
            craftedLink = [craftedLink stringByAppendingString:component];
        }
        else {
            craftedLink = [craftedLink stringByAppendingString:@"%"];
            craftedLink = [craftedLink stringByAppendingFormat:@"20%@", component];
        }
    }
    
    NSString *queryString = [NSString stringWithFormat:@"%@/geocode/search?text=%@&format=json&apiKey=%@", geoapifyBaseURLString, craftedLink, geoapify];
    NSURL *url = [NSURL URLWithString:queryString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);

            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            completion(nil, error);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary);
            
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

@end
