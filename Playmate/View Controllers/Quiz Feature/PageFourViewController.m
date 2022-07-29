//
//  PageFourViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "PageFourViewController.h"
#import "PageFiveViewController.h"
#import "TTGTextTagCollectionView.h"
#import "Constants.h"
#import "QuizHelpers.h"

@interface PageFourViewController () <TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;

@end

@implementation PageFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self setupTagCollectionView];
}

- (void)setupTagCollectionView {
    // Create TTGTextTagCollectionView view
    self.tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 300)];
    [self.view addSubview:self.tagCollectionView];
    self.tagCollectionView.delegate = self;
    
    // Get style and selected style for the tags
    TTGTextTagStyle *style = [QuizHelpers tagCollectionStyle];
    TTGTextTagStyle *selectedStyle = [QuizHelpers tagCollectionSelectedStyle];
    
    // Get sports list and create tags
    NSArray *allGendersList = [Constants gendersList];
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    for (NSString *gender in allGendersList) {
        TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:gender] style:[TTGTextTagStyle new]];
        textTag.style = style;
        textTag.selectedStyle = selectedStyle;
        [tagList addObject:textTag];
    }
    [self.tagCollectionView addTags:tagList];
}

- (IBAction)didTapClose:(id)sender {
    [QuizHelpers giveCloseWarningforViewController:self];
}

- (IBAction)didTapNext:(id)sender {
    [self performSegueWithIdentifier:@"fourToFive" sender:nil];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"fourToFive"]) {
         PageFiveViewController *vc = [segue destinationViewController];
         vc.dontPlaySportsList = self.dontPlaySportsList;
         vc.playSportsList = self.playSportsList;
         vc.gendersList = self.gendersList;
         vc.ageGroupsList = [QuizHelpers selectedStringsForTags:[self.tagCollectionView allSelectedTags]];
     }
 }

@end
