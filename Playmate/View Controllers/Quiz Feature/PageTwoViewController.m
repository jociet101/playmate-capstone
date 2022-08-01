//
//  PageTwoViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/28/22.
//

#import "PageTwoViewController.h"
#import "PageThreeViewController.h"
#import "TTGTextTagCollectionView.h"
#import "Constants.h"
#import "QuizHelpers.h"

@interface PageTwoViewController () <TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;

@end

@implementation PageTwoViewController

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
    NSArray *allSportsList = [Constants sportsList:NO];
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    for (NSString *sport in allSportsList) {
        if (![self.playSportsList containsObject:sport]) {
            TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:sport] style:[TTGTextTagStyle new]];
            textTag.style = style;
            textTag.selectedStyle = selectedStyle;
            [tagList addObject:textTag];
        }
    }
    [self.tagCollectionView addTags:tagList];
}

- (IBAction)didTapClose:(id)sender {
    [QuizHelpers giveCloseWarningforViewController:self];
}

- (IBAction)didTapNext:(id)sender {
    [self performSegueWithIdentifier:@"twoToThree" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"twoToThree"]) {
        PageThreeViewController *vc = [segue destinationViewController];
        vc.dontPlaySportsList = [QuizHelpers selectedStringsForTags:[self.tagCollectionView allSelectedTags]];
        vc.playSportsList = self.playSportsList;
    }
}

@end
