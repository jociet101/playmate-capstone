//
//  AppDelegate.m
//  Playmate
//
//  Created by Jocelyn Tseng on 6/29/22.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Keys" ofType: @"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];

        NSString *idee = [dict objectForKey: @"app_id"];
        NSString *key = [dict objectForKey: @"client_key"];
        
        // Check for launch arguments override
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"app_id"]) {
            idee = [[NSUserDefaults standardUserDefaults] stringForKey:@"app_id"];
        }
        if ([[NSUserDefaults standardUserDefaults] stringForKey:@"client_key"]) {
            key = [[NSUserDefaults standardUserDefaults] stringForKey:@"client_key"];
        }

        configuration.applicationId = idee;
        configuration.clientKey = key;
        configuration.server = @"https://parseapi.back4app.com";
    }];

    [Parse initializeWithConfiguration:config];

    return YES;
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
