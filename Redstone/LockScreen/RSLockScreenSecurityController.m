#import "Redstone.h"

@implementation RSLockScreenSecurityController

- (BOOL)deviceIsLocked {
	return [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked];
}

- (BOOL)deviceIsPasscodeLocked {
	return [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsPasscodeLocked];
	//return YES;
}

- (RSPasscodeKeyboardType)keyboardTypeForCurrentLockView {
	if (self.currentLockView) {
		if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewWithKeypad"]) {
			return RSPasscodeKeyboardTypeDigits;
		} else if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewWithKeyboard"]) {
			return RSPasscodeKeyboardTypeAlphanumeric;
		} else if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewSimpleFixedDigitKeypad"]) {
			return RSPasscodeKeyboardTypeDigits;
		} else if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewLongNumericKeypad"]) {
			return RSPasscodeKeyboardTypeDigitsWithConfirm;
		}
	}
	
	return RSPasscodeKeyboardTypeNone;
}

@end
