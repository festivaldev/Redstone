#import <Foundation/Foundation.h>

@class SBUIPasscodeLockViewBase;

@interface RSLockScreenSecurityController : NSObject {
	SBUIPasscodeLockViewBase* currentPasscodeLockView;
}

+ (id)sharedInstance;
- (SBUIPasscodeLockViewBase*)currentPasscodeLockView;
- (void)setCurrentPasscodeLockView:(SBUIPasscodeLockViewBase*)passcodeLockView;
- (BOOL)deviceIsLocked;
- (BOOL)deviceIsPasscodeLocked;
- (RSPasscodeLockViewType)passcodeLockViewType;

@end
