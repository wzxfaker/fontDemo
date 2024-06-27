#import "ColorSliderView.h"

@interface ColorSliderView ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
///icon
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation ColorSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化 UIImageView 并加载背景图片
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = [UIImage imageNamed:@"gradientImage"];
        _backgroundImageView.clipsToBounds = YES;
        [self addSubview:_backgroundImageView];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
        self.iconImageView.image = [UIImage imageNamed:@"backgroundImageName.jpg"];
        self.iconImageView.layer.cornerRadius = 10;
        self.iconImageView.clipsToBounds = YES;
        [self addSubview:self.iconImageView];
    }
    return self;
}

// 触摸事件开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleTouch:touches];
}

// 触摸事件移动
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self handleTouch:touches];
}

// 触摸事件处理
- (void)handleTouch:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    self.iconImageView.frame = CGRectMake(point.x-10, 5, 20, 20);
    UIColor *color = [self colorOfPoint:point inImageView:self.backgroundImageView];
    if (color) {
        if (self.touchedColor) {
            self.touchedColor(color);
        }
    }
}

// 获取指定点的颜色值
- (UIColor *)colorOfPoint:(CGPoint)point inImageView:(UIImageView *)imageView {
    UIImage *image = imageView.image;
    if (!image) {
        return nil;
    }
    CGSize viewSize = imageView.bounds.size;
    CGSize imageSize = image.size;
    CGPoint imagePoint = CGPointMake(point.x * (imageSize.width / viewSize.width),
                                     point.y * (imageSize.height / viewSize.height));
    if (imagePoint.x < 0 || imagePoint.x >= imageSize.width || imagePoint.y < 0 || imagePoint.y >= imageSize.height) {
        return nil;
    }
    // 获取图片的 CGImage
    CGImageRef cgImage = image.CGImage;
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    // 创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char pixelData[4] = { 0, 0, 0, 0 };

    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    // 绘制指定点的像素到位图上下文
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -imagePoint.x, -imagePoint.y);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);

    CGFloat red   = pixelData[0] / 255.0;
    CGFloat green = pixelData[1] / 255.0;
    CGFloat blue  = pixelData[2] / 255.0;
    CGFloat alpha = pixelData[3] / 255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

