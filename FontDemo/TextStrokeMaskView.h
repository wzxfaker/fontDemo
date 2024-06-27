//
//  TextStrokeMaskView.h
//  FontDemo
//
//  Created by wangzexin on 2024/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextStrokeMaskView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
