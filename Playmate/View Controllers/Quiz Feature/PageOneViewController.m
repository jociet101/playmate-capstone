//
//  PageOneViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/28/22.
//

#import "PageOneViewController.h"
#import "PageTwoViewController.h"
#import "TTGTextTagCollectionView.h"
#import "Constants.h"
#import "QuizHelpers.h"

@interface PageOneViewController () <TTGTextTagCollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (nonatomic, strong) TTGTextTagCollectionView *tagCollectionView;

@end

@implementation PageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSArray *sportsList = [Constants sportsList:NO];
    NSMutableArray *tagList = [[NSMutableArray alloc] init];
    for (NSString *sport in sportsList) {
        TTGTextTag *textTag = [TTGTextTag tagWithContent:[TTGTextTagStringContent contentWithText:sport] style:[TTGTextTagStyle new]];
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
    [self performSegueWithIdentifier:@"oneToTwo" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"oneToTwo"]) {
        PageTwoViewController *vc = [segue destinationViewController];
        // Extract sports from selected tags
        NSArray *selectedTags = [self.tagCollectionView allSelectedTags];
        NSMutableArray *selectedSports = [[NSMutableArray alloc] init];
        for (TTGTextTag *tag in selectedTags) {
            NSString *sport = [NSString stringWithFormat:@"%@", [tag.content getContentAttributedString]];
            [selectedSports addObject:[sport componentsSeparatedByString:@"{"][0]];
        }
        vc.playSportsList = (NSArray *)selectedSports;
    }
}

@end
