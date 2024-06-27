//
//  TextStrokeMaskView.m
//  FontDemo
//
//  Created by wangzexin on 2024/6/3.
//

#import "TextStrokeMaskView.h"
#import <CoreText/CoreText.h>

@interface TextStrokeMaskView ()

@property (nonatomic, assign) BOOL needsLayout;

@end

@implementation TextStrokeMaskView

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _text = text;
        _font = font;
        _needsLayout = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.needsLayout) {
        [self createTextLayout];
        self.needsLayout = NO;
    }
}

- (void)createTextLayout {
    // 创建 Core Text 富文本属性字典
    NSDictionary *attributes = @{NSFontAttributeName: self.font};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
    
    // 创建 Core Text 文本布局
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect bounds = self.bounds;
    CGPathAddRect(path, NULL, bounds);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributedString length]), path, NULL);
    
    // 获取文本笔画路径
    NSMutableArray *strokePaths = [NSMutableArray array];
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    for (id line in lines) {
        CTLineRef ctLine = (__bridge CTLineRef)line;
        CFArrayRef runs = CTLineGetGlyphRuns(ctLine);
        for (NSUInteger j = 0; j < CFArrayGetCount(runs); j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            NSUInteger glyphCount = CTRunGetGlyphCount(run);
            CGGlyph glyphs[glyphCount];
            CTRunGetGlyphs(run, CFRangeMake(0, 0), glyphs);
            CGPathRef runPath = CTFontCreatePathForGlyph(CTFontCreateWithFontDescriptor((__bridge CTFontDescriptorRef)self.font.fontDescriptor, 0, NULL), glyphs[0], NULL);
            [strokePaths addObject:(__bridge id)runPath];
            CFRelease(runPath);
        }
    }
    
    // 合并笔画路径
    CGMutablePathRef combinedPath = CGPathCreateMutable();
    for (id strokePath in strokePaths) {
        CGPathRef path = (__bridge CGPathRef)strokePath;
        CGPathAddPath(combinedPath, NULL, path);
    }
    
    // 创建遮罩图层
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = combinedPath;
    self.layer.mask = maskLayer;
    
    // 释放内存
    CGPathRelease(combinedPath);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
