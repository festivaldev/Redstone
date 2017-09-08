#import <UIKit/UIKit.h>
#import "RSPasscodeLockViewKeypadDelegate.h"

@class RSLockScreenPasscodeEntryTextField, RSTiltView;

@interface RSPasscodeLockViewLongNumericKeypad : UIView <RSPasscodeLockViewKeypadDelegate> {
	RSLockScreenPasscodeEntryTextField* passcodeTextField;
	RSTiltView* passcodeConfirmButton;
}

@end
