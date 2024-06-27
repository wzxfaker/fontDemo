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
    
    ParticleTextView *particleTextView = [[ParticleTextView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    particleTextView.text = @"你好";
    particleTextView.font = [UIFont systemFontOfSize:150 weight:UIFontWeightBold];
    particleTextView.particleColor = [UIColor redColor];
//    particleTextView.backgroundColor = [UIColor yellowColor];
    particleTextView.backgroundColor = [UIColor clearColor];
    self.particleTextView = particleTextView;
    [self.view addSubview:particleTextView];

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-300)*0.5, 430, 300, 200)];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"啦啦啦"];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:120 weight:UIFontWeightBold] range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImageName.jpg"]] range:NSMakeRange(0, attrStr.length)];
    label.attributedText = attrStr;
    label.backgroundColor = [UIColor orangeColor];
    label.hidden = YES;
    [self.view addSubview:label];
    
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = label.frame;
    [self.view addSubview:self.imageView];
    
    self.colorSliderView = [[ColorSliderView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.view.frame.size.width, 30)];
    self.colorSliderView.touchedColor = ^(UIColor * _Nonnull color) {
        self.particleTextView.particleColor = color;
        UIImage *image = [self.particleTextView convertToImage];
        self.imageView.image = image;
    };
    [self.view addSubview:self.colorSliderView];
    
    
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
//    [self.view addGestureRecognizer:longG];
    
}

- (void)handleLongPress {
    UIColor *color = [UIColor colorWithRed:(arc4random() % 256)*1.0/256 green:(arc4random() % 256)*1.0/256 blue:(arc4random() % 256)*1.0/256 alpha:1.0];
    self.particleTextView.particleColor = color;
    self.particleTextView.font = [UIFont systemFontOfSize:arc4random() % 50+100 weight:UIFontWeightBold];
    self.particleTextView.text = @"我很好";
    UIImage *image = [self.particleTextView convertToImage];
    self.imageView.image = image;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UIColor *color = [UIColor colorWithRed:(arc4random() % 256)*1.0/256 green:(arc4random() % 256)*1.0/256 blue:(arc4random() % 256)*1.0/256 alpha:1.0];
    self.particleTextView.particleColor = color;
    self.particleTextView.font = [UIFont systemFontOfSize:120 weight:UIFontWeightBold];
    self.particleTextView.text = @"我很好";
    UIImage *image = [self.particleTextView convertToImage];
    self.imageView.image = image;
}


@end
