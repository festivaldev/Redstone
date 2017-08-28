#import <UIKit/UIKit.h>
#import "UI/RSTiltView.h"
#import <SpringBoardUIServices/SBUIPasscodeLockViewWithKeypad.h>

@class RSTiltView, SBPasscodeNumberPadButton;

@interface SBPasscodeNumberPadButton : UIView

- (id)stringCharacter;

@end



@interface RSLockScreenPasscodeEntryButton : RSTiltView

@property (nonatomic, assign) BOOL isBackspaceButton;
@property (nonatomic, strong) SBPasscodeNumberPadButton* numberPadButton;

@end
