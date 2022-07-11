//
//  LocationPickerCell.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/9/22.
//

#import "LocationPickerCell.h"
#import "SelectMapViewController.h"

@interface LocationPickerCell ()

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

@end
