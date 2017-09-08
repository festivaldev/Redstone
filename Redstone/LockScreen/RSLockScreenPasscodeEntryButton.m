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
	if (sender.state == UIGestureRecognizerStateBegan) {
		if (self.isBackspaceButton) {
			[(SBUIPasscodeLockViewWithKeypad*)[[RSLockScreenSecurityController sharedInstance] currentPasscodeLockView] passcodeLockNumberPadBackspaceButtonHit:nil];
		} else {
			[(SBUIPasscodeLockViewWithKeypad*)[[RSLockScreenSecurityController sharedInstance] currentPasscodeLockView] passcodeLockNumberPad:nil keyDown:self.numberPadButton];
		}
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		if (self.isBackspaceButton) {} else {
			
			[(SBUIPasscodeLockViewWithKeypad*)[[RSLockScreenSecurityController sharedInstance] currentPasscodeLockView] passcodeLockNumberPad:nil keyUp:self.numberPadButton];
		}
	}
}

@end
