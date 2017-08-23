#import <UIKit/UIKit.h>

@interface SpringBoard : UIApplication;

+ (id)sharedApplication;
- (id)_accessibilityFrontMostApplication;
- (BOOL)_isDim;

@end
