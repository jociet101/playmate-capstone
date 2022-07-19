//
//  SelectMapHelpViewController.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/19/22.
//

#import "SelectMapHelpViewController.h"
#import "Constants.h"

@interface SelectMapHelpViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *enterAddressGifView;
@property (weak, nonatomic) IBOutlet UIImageView *tapOnMapGifView;

@end

@implementation SelectMapHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *addressGif = [UIImage animatedImageWithImages:[Constants addressGifImages] duration:9.0f];
    [self.enterAddressGifView setImage:addressGif];
    
    UIImage *manualGif = [UIImage animatedImageWithImages:[Constants manualGifImages] duration:9.0f];
    [self.tapOnMapGifView setImage:manualGif];
}

- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
