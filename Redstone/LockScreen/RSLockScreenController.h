#import <UIKit/UIKit.h>

@class RSLockScreenSecurityController, RSLockScreenView;

@interface RSLockScreenController : NSObject

@property (nonatomic, strong) RSLockScreenSecurityController* securityController;
@property (nonatomic, strong) RSLockScreenView* view;

@end
