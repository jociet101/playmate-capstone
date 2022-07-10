//
//  LocationPickerCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "LocationPickerCell.h"
#import "SelectMapViewController.h"

@interface LocationPickerCell () <SelectMapViewControllerDelegate>

// will appear if user selected location
@property (weak, nonatomic) IBOutlet UIImageView *checkmark;
@property (nonatomic, strong) Location * _Nullable selectedLocation;

@end

@implementation LocationPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRowNumber:(NSNumber *)rowNumber {
    self.checkmark.alpha = 0;
}

#pragma mark - Select map vc protocol method

- (void)getSelectedLocation:(Location *)location {
    self.selectedLocation = location;
    self.checkmark.alpha = 1;
}

- (IBAction)didTapSelectLocation:(id)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toSelectLocation"]) {
        SelectMapViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        NSLog(@"location picker cell set vc delegate to be self");
    }
}

@end
