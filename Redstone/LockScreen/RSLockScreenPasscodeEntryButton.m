#import "Redstone.h"

@implementation RSLockScreenPasscodeEntryButton

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setHighlightEnabled:YES];
		[self setColoredHighlight:YES];
		[self.titleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:38]];
		[self.titleLabel setTextColor:[UIColor whiteColor]];
		
		[tiltGestureRecognizer setEnabled:NO];
		
		UILongPressGestureRecognizer* longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(numberPadButtonPressed:)];
		[longPressGestureRecognizer setMinimumPressDuration:0];
		[longPressGestureRecognizer setCancelsTouchesInView:NO];
		[longPressGestureRecognizer setDelaysTouchesBegan:NO];
		[longPressGestureRecognizer setDelaysTouchesEnded:NO];
		[self addGestureRecognizer:longPressGestureRecognizer];
	}
	
	return self;
}

- (void)numberPadButtonPressed:(UILongPressGestureRecognizer*)sender {
	/*if (self.numberPadButton && !self.isBackspaceButton) {
		if ([[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewWithKeypad")]) {
			//[(SBUIPasscodeLockViewWithKeypad*)[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcodeLockNumberPad:nil keyDown:self.numberPadButton];
			
			[(SBUIPasscodeLockViewWithKeypad*)[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcodeLockNumberPad:nil keyDown:self.numberPadButton];
			[(SBUIPasscodeLockViewWithKeypad*)[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcodeLockNumberPad:nil keyUp:self.numberPadButton];
		}
	}*/
	
	
	
	if (sender.state == UIGestureRecognizerStateBegan) {
		if (self.isBackspaceButton) {
			if ([[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewLongNumericKeypad")]) {
				[[[[[RSCore sharedInstance] lockScreenController] view] passcodeEntryView] removeCharacter];
			} else {
				[(SBUIPasscodeLockViewWithKeypad*)[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcodeLockNumberPadBackspaceButtonHit:nil];
			}
		} else {
			if ([[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewLongNumericKeypad")]) {
				[[[[[RSCore sharedInstance] lockScreenController] view] passcodeEntryView] addTextToPasscode:[self.numberPadButton stringCharacter]];
			} else {
				[(SBUIPasscodeLockViewWithKeypad*)[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcodeLockNumberPad:nil keyDown:self.numberPadButton];
			}
		}
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		if (self.isBackspaceButton) {} else {
			if ([[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] isKindOfClass:NSClassFromString(@"SBUIPasscodeLockViewLongNumericKeypad")]) {
				
			} else {
				[(SBUIPasscodeLockViewWithKeypad*)[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcodeLockNumberPad:nil keyUp:self.numberPadButton];
			}
		}
	}
}

@end
