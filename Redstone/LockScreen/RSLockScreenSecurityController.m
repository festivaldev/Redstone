#import "Redstone.h"

@implementation RSLockScreenSecurityController

static RSLockScreenSecurityController* sharedInstance;

+ (id)sharedInstance {
	return sharedInstance;
}

- (id)init {
	if (self = [super init]) {
		sharedInstance = self;
		currentPasscodeLockView = [objc_getClass("SBUIPasscodeLockViewBase") currentPasscodeView];
	}
	
	return self;
}

- (SBUIPasscodeLockViewBase*)currentPasscodeLockView {
	return currentPasscodeLockView;
}

- (void)setCurrentPasscodeLockView:(SBUIPasscodeLockViewBase *)passcodeLockView {
	currentPasscodeLockView = passcodeLockView;
}
- (BOOL)deviceIsLocked {
	return [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsLocked];
}

- (BOOL)deviceIsPasscodeLocked {
	return [[objc_getClass("SBUserAgent") sharedUserAgent] deviceIsPasscodeLocked];
}

- (RSPasscodeLockViewType)passcodeLockViewType {
	if ([currentPasscodeLockView isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewSimpleFixedDigitKeypad")]) {
		return RSPasscodeLockViewTypeFixedDigit;
	} else if ([currentPasscodeLockView isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewLongNumericKeypad")]) {
		return RSPasscodeLockViewTypeLongNumeric;
	} else if ([currentPasscodeLockView isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewWithKeyboard")]) {
		return RSPasscodeLockViewTypeAlphanumeric;
	}
	
	return RSPasscodeLockViewTypeNone;
}

@end
