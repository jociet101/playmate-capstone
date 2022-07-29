//
//  PageOneViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/28/22.
//

#import "PageOneViewController.h"
#import "TTGTextTagCollectionView.h"
#import "Constants.h"

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
    int width = self.view.frame.size.width - 40;
    // Create TTGTextTagCollectionView view
    self.tagCollectionView = [[TTGTextTagCollectionView alloc] initWithFrame:CGRectMake(20, 200, width, 300)];
    [self.view addSubview:self.tagCollectionView];
    self.tagCollectionView.delegate = self;
    
    // Design style and selected style for the tags
    TTGTextTagStringContent *content = [TTGTextTagStringContent new];
    TTGTextTagStringContent *selectedContent = [TTGTextTagStringContent new];
    TTGTextTagStyle *style = [TTGTextTagStyle new];
    TTGTextTagStyle *selectedStyle = [TTGTextTagStyle new];
    
    content.textFont = [UIFont boldSystemFontOfSize:30.0f];
    selectedContent.textFont = content.textFont;
    
    content.textColor = [UIColor blackColor];
    selectedContent.textColor = [UIColor blackColor];
    
    style.backgroundColor = [UIColor whiteColor];
    selectedStyle.backgroundColor = [UIColor systemMintColor];

    style.borderColor = [UIColor blackColor];
    style.borderWidth = 1;
    selectedStyle.borderColor = [UIColor blackColor];
    selectedStyle.borderWidth = 1;

    style.cornerRadius = 4;
    selectedStyle.cornerRadius = 4;
    
    style.extraSpace = CGSizeMake(12, 12);
    selectedStyle.extraSpace = style.extraSpace;
    
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

#pragma mark - Text Tag Collection View Delegate Methods

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapNext:(id)sender {
    [self performSegueWithIdentifier:@"oneToTwo" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"oneToTwo"]) {
        // save desired sports
    }
}

@end
