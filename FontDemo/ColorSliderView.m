//
//  ColorSliderView.m
//  FontDemo
//
//  Created by wangzexin on 2024/6/26.
//

#import "ColorSliderView.h"

@interface ColorSliderView ()

///<##>
@property (nonatomic, strong) UIImageView *gradientImageView;
///<##>
@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation ColorSliderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    self.gradientImageView = [[UIImageView alloc] init];
    self.gradientImageView.image = [UIImage imageNamed:@"gradientImage"];
    [self addSubview:self.gradientImageView];
    
    self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImageName.jpg"]];
    self.iconImageView.frame = CGRectMake(0, 5, 20, 20);
    self.iconImageView.layer.cornerRadius = 10;
    self.iconImageView.clipsToBounds = YES;
    [self addSubview:self.iconImageView];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.gradientImageView.image) {
        [self.gradientImageView.image drawInRect:self.bounds];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.gradientImageView.frame = self.bounds;
}

- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    UIColor *color = nil;
    // 创建1x1像素的位图上下文
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    if (context) {
        // 将要检查的点的像素绘制到1x1的位图上下文中
        CGContextTranslateCTM(context, -point.x, -point.y);
        [self.layer renderInContext:context];
        
        // 获取颜色值
        color = [UIColor colorWithRed:pixel[0] / 255.0
                                green:pixel[1] / 255.0
                                 blue:pixel[2] / 255.0
                                alpha:pixel[3] / 255.0];
        CGContextRelease(context);
    }
    return color;
}

- (UIColor *)colorOfPoint:(CGPoint)point inImage:(UIImage *)image {
    // 确保点在视图范围内
    if (!CGRectContainsPoint(self.bounds, point)) {
        return nil;
    }

    // 计算视图坐标和图片坐标之间的比例
    CGSize imageSize = image.size;
    CGSize viewSize = self.bounds.size;

    CGFloat xRatio = imageSize.width / viewSize.width;
    CGFloat yRatio = imageSize.height / viewSize.height;
    NSLog(@"🏀🏀scale--%d", image.scale);
    // 将视图坐标转换为图片坐标
    CGPoint imagePoint = CGPointMake(point.x * xRatio, point.y * yRatio);

    CGImageRef cgImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(cgImage);
    NSUInteger height = CGImageGetHeight(cgImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *)calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
    CGContextRelease(context);
    
    int byteIndex = (bytesPerRow * imagePoint.y) + imagePoint.x * bytesPerPixel;
    CGFloat red = rawData[byteIndex] / 255.0;
    CGFloat green = rawData[byteIndex + 1] / 255.0;
    CGFloat blue = rawData[byteIndex + 2] / 255.0;
    CGFloat alpha = rawData[byteIndex + 3] / 255.0;
    
    free(rawData);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self.gradientImageView];
    self.iconImageView.frame = CGRectMake(point.x-10, 5, 20, 20);
//    UIColor *color = [self colorOfPoint:point];
    UIColor *color = [self colorOfPoint:point inImage:[UIImage imageNamed:@"gradientImage"]];
    if (self.touchedColor) {
        self.touchedColor(color);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    self.iconImageView.frame = CGRectMake(point.x-10, 5, 20, 20);
    UIColor *color = [self colorOfPoint:point];
    if (self.touchedColor) {
        self.touchedColor(color);
    }
}


@end
