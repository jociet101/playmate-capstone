//
//  QuizHelpers.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TTGTextTagCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuizHelpers : NSObject

// Give user warning when try to close quiz window
+ (void)giveCloseWarningforViewController:(id)viewController;
+ (TTGTextTagStyle *)tagCollectionStyle;
+ (TTGTextTagStyle *)tagCollectionSelectedStyle;
+ (NSArray *)selectedStringsForTags:(NSArray *)selectedTags;

@end

NS_ASSUME_NONNULL_END
