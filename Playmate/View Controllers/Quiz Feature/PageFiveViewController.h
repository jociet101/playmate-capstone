//
//  PageFiveViewController.h
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QuizDoneDelegate <NSObject>

- (void)quizDoneMessage;

@end

@interface PageFiveViewController : UIViewController

@property (nonatomic, strong) NSArray *playSportsList;
@property (nonatomic, strong) NSArray *dontPlaySportsList;
@property (nonatomic, strong) NSArray *gendersList;
@property (nonatomic, strong) NSArray *ageGroupsList;

@property (nonatomic, strong) id<QuizDoneDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
