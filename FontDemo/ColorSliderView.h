//
//  ColorSliderView.h
//  FontDemo
//
//  Created by wangzexin on 2024/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ColorSliderView : UIView

///<##>
@property (nonatomic, copy) void(^touchedColor)(UIColor *color);

@end

NS_ASSUME_NONNULL_END
