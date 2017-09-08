#import <UIKit/UIKit.h>
#import "RSPasscodeLockViewKeypadDelegate.h"

@class RSLockScreenPasscodeEntryTextField;

@interface RSPasscodeLockViewSimpleFixedDigitKeypad : UIView <RSPasscodeLockViewKeypadDelegate> {
	RSLockScreenPasscodeEntryTextField* passcodeTextField;
}

@end
