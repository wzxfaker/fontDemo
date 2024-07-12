#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PreviewType) {
    PreviewTypeText = 0,//文字
    PreviewTypeImage = 1,//图片
};

@interface ParticleTextView : UIView

///<##>
@property (nonatomic, assign) PreviewType type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *particleColor;
@property (nonatomic, assign) CGFloat particleSize;
///<##>
@property (nonatomic, strong) UIImage *image;

@end

