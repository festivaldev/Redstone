#import <UIKit/UIKit.h>

@interface RSAnimation : NSObject

+ (CGFloat)startScreenAnimationDelay;
+ (void)startScreenAnimateOut;
+ (void)startScreenAnimateIn;

+ (CGFloat)appListAnimationDelay;
+ (void)appListAnimateOut;
+ (void)appListAnimateIn;

@end
