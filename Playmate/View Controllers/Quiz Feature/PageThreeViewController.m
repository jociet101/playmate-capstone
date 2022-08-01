//
//  PageThreeViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/29/22.
//

#import "PageThreeViewController.h"
#import "PageFourViewController.h"
#import "TTGTextTagCollectionView.h"
#import "Constants.h"
#import "QuizHelpers.h"

@interface PageThreeViewController () <TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;

@end

@implementation PageThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self setupTagCollectionView];
}

- (void)setupTagCollectionView {
    // Create TTGTextTagCollectionView view
    self.tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 220, self.view.frame.size.width - 40, 300)];
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
    [self performSegueWithIdentifier:@"threeToFour" sender:nil];
}

#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"threeToFour"]) {
         PageFourViewController *vc = [segue destinationViewController];
         vc.dontPlaySportsList = self.dontPlaySportsList;
         vc.playSportsList = self.playSportsList;
         vc.gendersList = [QuizHelpers selectedStringsForTags:[self.tagCollectionView allSelectedTags]];
     }
 }

@end
