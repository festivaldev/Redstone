#import "Redstone.h"
#import <SpringBoardUIServices/SBUIPasscodeLockViewBase.h>

@implementation RSLockScreenSecurityController

- (id)init {
	if (self = [super init]) {
		//self.passcodeEntryView = [[RSLockScreenPasscodeEntryView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 382)];
	}
	
	return self;
}

- (BOOL)deviceIsLocked {
	return [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked];
}

- (BOOL)deviceIsPasscodeLocked {
	return [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsPasscodeLocked];
	//return YES;
}

- (RSPasscodeKeyboardType)keyboardTypeForCurrentLockView {
	if (self.currentLockView) {		
		if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewLongNumericKeypad"]) {
			return RSPasscodeKeyboardTypeDigitsWithConfirm;
		} else if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewSimpleFixedDigitKeypad"]) {
			return RSPasscodeKeyboardTypeDigits;
		} else if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewWithKeyboard"]) {
			return RSPasscodeKeyboardTypeAlphanumeric;
		} else if ([NSStringFromClass([self.currentLockView class]) isEqualToString:@"SBUIPasscodeLockViewWithKeypad"]) {
			return RSPasscodeKeyboardTypeDigits;
		}
	}
	
	return RSPasscodeKeyboardTypeNone;
}

- (void)setCurrentLockView:(SBUIPasscodeLockViewBase *)currentLockView {
	_currentLockView = currentLockView;
	[[[[[RSCore sharedInstance] lockScreenController] view] passcodeEntryView] setKeypadForPasscodeType:[self keyboardTypeForCurrentLockView]];
}

@end
