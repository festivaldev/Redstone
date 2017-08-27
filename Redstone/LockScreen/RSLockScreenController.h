#import <UIKit/UIKit.h>

@class RSLockScreenView, RSLockScreenSecurityController;

@interface RSLockScreenController : NSObject

@property (nonatomic, strong) RSLockScreenView* view;
@property (nonatomic, strong) RSLockScreenSecurityController* securityController;

@end
