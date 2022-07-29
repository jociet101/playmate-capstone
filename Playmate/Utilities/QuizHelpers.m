//
//  QuizHelpers.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "QuizHelpers.h"

@implementation QuizHelpers

// Give user warning when try to close quiz window
+ (void)giveCloseWarningforViewController:(id)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Your progress will be lost." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:closeAction];
    [viewController presentViewController:alertController animated: YES completion: nil];
}

#pragma mark - Tag Collection View

+ (TTGTextTagStyle *)tagCollectionStyle {
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    style.backgroundColor = [UIColor whiteColor];
    style.borderColor = [UIColor blackColor];
    style.borderWidth = 1;
    style.cornerRadius = 4;
    style.extraSpace = CGSizeMake(12, 12);
    return style;
}

+ (TTGTextTagStyle *)tagCollectionSelectedStyle {
    TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];
    selectedStyle.backgroundColor = [UIColor systemMintColor];
    selectedStyle.borderColor = [UIColor blackColor];
    selectedStyle.borderWidth = 1;
    selectedStyle.cornerRadius = 4;
    selectedStyle.extraSpace = CGSizeMake(12, 12);
    return selectedStyle;
}

+ (NSArray *)selectedStringsForTags:(NSArray *)selectedTags {
    NSMutableArray *selectedStrings = [[NSMutableArray alloc] init];
    for (TTGTextTag *tag in selectedTags) {
        NSString *string = [NSString stringWithFormat:@"%@", [tag.content getContentAttributedString]];
        [selectedStrings addObject:[string componentsSeparatedByString:@"{"][0]];
    }
    return (NSArray *)selectedStrings;
}

@end
