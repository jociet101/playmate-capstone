//
//  PageFiveViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "PageFiveViewController.h"
#import "Constants.h"
#import "Helpers.h"
#import "Strings.h"
#import "QuizHelpers.h"
#import "QuizResult.h"

@interface PageFiveViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@end

@implementation PageFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction)didTapClose:(id)sender {
    [QuizHelpers giveCloseWarningforViewController:self];
}

- (IBAction)didTapDone:(id)sender {
    PFUser *me = [[PFUser currentUser] fetchIfNeeded];
    NSString *resultObjectId = [me objectForKey:@"quizResult"][0];
    if (resultObjectId != nil) {
        QuizResult *result = [PFQuery getObjectOfClass:@"QuizResult" objectId:resultObjectId error:nil];
        [result deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self saveQuizResult];
        }];
    } else {
        [self saveQuizResult];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveQuizResult {
    [QuizResult saveQuizResultWithSports:self.playSportsList
                            andNotSports:self.dontPlaySportsList
                              andGenders:self.gendersList
                                 andAges:self.ageGroupsList
                          withCompletion:^(BOOL success, NSError * _Nonnull error) {
        if (success) {
            PFUser *me = [[PFUser currentUser] fetchIfNeeded];
            PFQuery *query = [PFQuery queryWithClassName:@"QuizResult"];
            [query whereKey:@"userObjectId" equalTo:me.objectId];
            QuizResult *result = [query getFirstObject];
            [me addObject:result.objectId forKey:@"quizResult"];
            [me saveInBackground];
        } else {
            [Helpers handleAlert:error withTitle:[Strings errorString] withMessage:nil forViewController:self];
        }
    }];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 }

@end
