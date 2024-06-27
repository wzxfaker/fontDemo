//
//  UIView+Image.m
//  FontDemo
//
//  Created by wangzexin on 2024/6/26.
//

#import "UIView+Image.h"

@implementation UIView (Image)

- (UIImage *)convertToImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
