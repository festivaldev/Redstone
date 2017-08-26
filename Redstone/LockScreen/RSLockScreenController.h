#import <UIKit/UIKit.h>

@class RSLockScreenView;

@interface RSLockScreenController : NSObject

@property (nonatomic, strong) RSLockScreenView* view;

- (void)resetLockScreen;

@end
