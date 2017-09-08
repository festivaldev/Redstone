#import <UIKit/UIKit.h>
#import "RSPasscodeLockViewKeypadDelegate.h"

@class RSLockScreenPasscodeEntryTextField, SBPasscodeKeyboard;

@interface RSPasscodeLockViewAlphanumericKeyboard : UIView <RSPasscodeLockViewKeypadDelegate> {
	RSLockScreenPasscodeEntryTextField* passcodeTextField;
}

- (id)initWithFrame:(CGRect)frame passcodeKeyboard:(SBPasscodeKeyboard*)passcodeKeyboard;

@end
