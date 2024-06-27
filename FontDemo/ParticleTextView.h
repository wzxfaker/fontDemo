#import <UIKit/UIKit.h>

@interface ParticleTextView : UIView

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *particleColor;
@property (nonatomic, assign) CGFloat particleSize;

@end

