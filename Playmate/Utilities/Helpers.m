//
//  Helpers.m
//  Playmate
//
//  Created by Jocelyn Tseng on 7/15/22.
//

#import "Helpers.h"

@implementation Helpers

// for resizing images
+ (UIImage *)resizeImage:(UIImage *)image withDimension:(int)dimension {
    
    CGSize size = CGSizeMake(dimension, dimension);
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dimension, dimension)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
