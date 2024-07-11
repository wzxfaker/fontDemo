//
//  ParticleTextView.m
//  FontDemo
//
//  Created by wangzexin on 2024/5/31.
//

#import "ParticleTextView.h"
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@implementation ParticleTextView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 清除上次绘制的内容
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (self.image) {
        // 获取图片在视图中的绘制区域
        CGRect imageRect = self.bounds;
        // 绘制图片
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, imageRect.size.height);
        CGContextScaleCTM(context, -1.0, -1.0);
        CGContextDrawImage(context, imageRect, self.image.CGImage);
        CGContextRestoreGState(context);
        //根据图像的透明度通道来定义裁剪区域
        CGContextClipToMask(context, imageRect, self.image.CGImage);
        [self drawParticlesAlongPath:[UIBezierPath bezierPathWithRect:imageRect].CGPath inContext:context];        
        //恢复坐标系
        CGContextRestoreGState(context);
    } else {
        if (self.text && self.font) {
            CGPathRef textPath = [self createTextPath];
            if (textPath) {
                [self drawParticlesAlongPath:textPath inContext:context];
                CGPathRelease(textPath);
            }
        }
    }
}

- (CGPathRef)createTextPath {
    NSDictionary *attributes = @{NSFontAttributeName: self.font,
                                 NSForegroundColorAttributeName: [UIColor clearColor]};
    
    CGMutablePathRef textPath = CGPathCreateMutable();
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attributedText);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CFDictionaryRef attributes = CTRunGetAttributes(run);
        CTFontRef runFont = CFDictionaryGetValue(attributes, kCTFontAttributeName);
        
        for (CFIndex glyphIndex = 0; glyphIndex < CTRunGetGlyphCount(run); glyphIndex++) {
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, CFRangeMake(glyphIndex, 1), &glyph);
            CTRunGetPositions(run, CFRangeMake(glyphIndex, 1), &position);
            
            CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
            transform = CGAffineTransformScale(transform, 1.0, -1.0); // Flip Y axis
            CGPathAddPath(textPath, &transform, glyphPath);
            CGPathRelease(glyphPath);
        }
    }
    
    CFRelease(line);
    // Center the path in the view
    CGRect boundingBox = CGPathGetBoundingBox(textPath);
    CGAffineTransform translation = CGAffineTransformMakeTranslation((CGRectGetWidth(self.bounds) - CGRectGetWidth(boundingBox)) / 2.0,
                                                                     (CGRectGetHeight(self.bounds) + CGRectGetHeight(boundingBox)) / 2.0);
    CGPathRef translatedPath = CGPathCreateCopyByTransformingPath(textPath, &translation);
    CGPathRelease(textPath);
    
    return translatedPath;
}

- (void)drawParticlesAlongPath:(CGPathRef)path inContext:(CGContextRef)context {
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    // 设置粒子颜色
    UIColor *particleColor = self.particleColor ?: [UIColor yellowColor];
    NSInteger size = self.particleSize != 0 ? self.particleSize : 3;
    // 在路径上绘制粒子
    CGRect boundingBox = CGPathGetBoundingBox(path);
    for (CGFloat x = CGRectGetMinX(boundingBox); x < CGRectGetMaxX(boundingBox); x += size) {
        for (CGFloat y = CGRectGetMinY(boundingBox); y < CGRectGetMaxY(boundingBox); y += size) {
            if (CGPathContainsPoint(path, NULL, CGPointMake(x, y), NO)) {
                CGFloat particleSize = ((CGFloat)arc4random_uniform((size-1)*1000.0+501) / 1000.0) + 0.5;
                CGRect particleRect = CGRectMake(x, y, particleSize, particleSize);
                CGContextSetFillColorWithColor(context, particleColor.CGColor);
                CGContextFillEllipseInRect(context, particleRect);
            }
        }
    }
    
    CGContextRestoreGState(context);
}


- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self setNeedsDisplay];
}

- (void)setParticleColor:(UIColor *)particleColor {
    _particleColor = particleColor;
    [self setNeedsDisplay];
}

- (void)setParticleSize:(CGFloat)particleSize {
    _particleSize = particleSize;
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

@end
