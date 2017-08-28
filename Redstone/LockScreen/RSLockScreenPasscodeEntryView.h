#import <UIKit/UIKit.h>
#import <SpringBoardUIServices/SBUIPasscodeLockNumberPad.h>
#import <SpringBoardUIServices/SBUIPasscodeLockViewBase.h>

@class RSLockScreenPasscodeEntryTextField, RSTiltView;

@interface RSLockScreenPasscodeEntryView : UIView <UITextFieldDelegate> {
	RSLockScreenPasscodeEntryTextField* passcodeTextField;
	RSTiltView* passcodeConfirmButton;
	int currentPasscodeType;
}

- (void)handlePasscodeTextChanged;
- (void)handleFailedAuthentication;
- (void)handleFailedMesaAuthentication;
- (void)setKeypadForPasscodeType:(RSPasscodeKeyboardType)passcodeType;
- (void)resetPasscodeText;
- (void)addTextToPasscode:(NSString*)text;
- (void)removeCharacter;

@end
