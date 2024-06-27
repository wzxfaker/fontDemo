//
//  ParticleTextView.m
//  FontDemo
//
//  Created by wangzexin on 2024/5/31.
//

#import "ParticleTextView.h"
#import <CoreText/CoreText.h>

@implementation ParticleTextView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 清除上次绘制的内容
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    if (self.text && self.font) {
        NSDictionary *attributes = @{NSFontAttributeName: self.font,
                                     NSForegroundColorAttributeName: [UIColor clearColor]};
        
        // 获取文本路径
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
                transform = CGAffineTransformScale(transform, 1.0, -1.0); // 反转 Y 轴
                CGPathAddPath(textPath, &transform, glyphPath);
                CGPathRelease(glyphPath);
            }
        }
        
        CFRelease(line);
        
        // 将路径移动到视图的中心
        CGRect boundingBox = CGPathGetBoundingBox(textPath);
        CGAffineTransform translation = CGAffineTransformMakeTranslation((CGRectGetWidth(rect) - CGRectGetWidth(boundingBox)) / 2.0,
                                                                         (CGRectGetHeight(rect) + CGRectGetHeight(boundingBox)) / 2.0);
        CGPathRef translatedPath = CGPathCreateCopyByTransformingPath(textPath, &translation);
        CGPathRelease(textPath);

        // 绘制粒子效果
        [self drawParticlesAlongPath:translatedPath inContext:UIGraphicsGetCurrentContext()];
        
        CGPathRelease(translatedPath);
    }
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

@end
