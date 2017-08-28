#import <Foundation/Foundation.h>
#import <SpringBoardUIServices/SBUIPasscodeLockViewBase.h>

typedef NS_ENUM(NSUInteger, RSPasscodeKeyboardType) {
	RSPasscodeKeyboardTypeNone,
	RSPasscodeKeyboardTypeDigits,
	RSPasscodeKeyboardTypeDigitsWithConfirm,
	RSPasscodeKeyboardTypeAlphanumeric
};

@interface RSLockScreenSecurityController : NSObject

@property (nonatomic, strong) SBUIPasscodeLockViewBase* currentLockView;

- (BOOL)deviceIsLocked;
- (BOOL)deviceIsPasscodeLocked;
- (RSPasscodeKeyboardType)keyboardTypeForCurrentLockView;

@end
