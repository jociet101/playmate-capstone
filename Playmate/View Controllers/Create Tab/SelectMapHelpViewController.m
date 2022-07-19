//
//  SelectMapHelpViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/19/22.
//

#import "SelectMapHelpViewController.h"

@interface SelectMapHelpViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *enterAddressGifView;
@property (weak, nonatomic) IBOutlet UIImageView *tapOnMapGifView;

@end

@implementation SelectMapHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *addressGifImages = [[NSMutableArray alloc] initWithCapacity:155];
    for (int i = 0; i < 155; i++) {
        [addressGifImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"address_%d", i]]];
    }
    
    UIImage *addressGif = [UIImage animatedImageWithImages:(NSArray *)addressGifImages duration:9.0f];
    [self.enterAddressGifView setImage:addressGif];
    
    NSMutableArray *manualGifImages = [[NSMutableArray alloc] initWithCapacity:93];
    for (int i = 0; i < 93; i++) {
        [manualGifImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"frame_%d", i]]];
    }
    
    UIImage *manualGif = [UIImage animatedImageWithImages:(NSArray *)manualGifImages duration:9.0f];
    [self.tapOnMapGifView setImage:manualGif];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
