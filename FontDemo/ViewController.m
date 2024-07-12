//
//  ViewController.m
//  FontDemo
//
//  Created by wangzexin on 2024/5/31.
//

#import "ViewController.h"
#import "ParticleTextView.h"
#import "TextStrokeMaskView.h"
#import "UIView+Image.h"
#import "ColorSliderView.h"

#ifndef weakify
    #if __has_feature(objc_arc)
    #define weakify(object) __weak __typeof__(object) weak##_##object = object;
    #else
    #define weakify(object) __block __typeof__(object) block##_##object = object;
    #endif
#endif

#ifndef strongify
    #if __has_feature(objc_arc)
    #define strongify(object) __typeof__(object) object = weak##_##object;
    #else
    #define strongify(object) __typeof__(object) object = block##_##object;
    #endif
#endif

@interface ViewController ()

///<##>
@property (nonatomic, strong) ParticleTextView *particleTextView;
///<##>
@property (nonatomic, strong) UIImageView *imageView;
///<##>
@property (nonatomic, assign) NSInteger size;
///<##>
@property (nonatomic, strong) ColorSliderView *colorSliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ParticleTextView *particleTextView = [[ParticleTextView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width-300)*0.5, 100, 300, 300)];
    particleTextView.type = PreviewTypeText;
    particleTextView.image = [UIImage imageNamed:@"3"];
    particleTextView.text = @"你好";
    particleTextView.font = [UIFont systemFontOfSize:150 weight:UIFontWeightBold];
    particleTextView.particleColor = [UIColor redColor];
    particleTextView.backgroundColor = [UIColor clearColor];
    self.particleTextView = particleTextView;
    [self.view addSubview:particleTextView];

    
    //字体添加背景图片
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)*0.5, 430, 300, 200)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"啦啦啦"];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:120 weight:UIFontWeightBold] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImageName.jpg"]] range:NSMakeRange(0, attrStr.length)];
    label.attributedText = attrStr;
    label.backgroundColor = [UIColor orangeColor];
    label.hidden = YES;
    [self.view addSubview:label];
    
    //获取截图展示的imageView
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake((self.view.bounds.size.width-200)*0.5, 430, 200, 200);
    [self.view addSubview:self.imageView];
    
    self.colorSliderView = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.view.frame.size.width, 30)];
    weakify(self);
    self.colorSliderView.touchedColor = ^(UIColor * _Nonnull color) {
        strongify(self);
        self.particleTextView.particleColor = color;
        UIImage *image = [self.particleTextView convertToImage];
        self.imageView.image = image;
    };
    [self.view addSubview:self.colorSliderView];

}


@end
