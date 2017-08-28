#import "Redstone.h"

@implementation RSLockScreenPasscodeEntryView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		//[self setBackgroundColor:[UIColor magentaColor]];
		
		passcodeTextField = [[RSLockScreenPasscodeEntryTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 55)];
		[passcodeTextField setDelegate:self];
		[passcodeTextField setUserInteractionEnabled:NO];
		
		passcodeConfirmButton = [[RSTiltView alloc] initWithFrame:CGRectMake(0, 0, 0, 55)];
		[passcodeConfirmButton setBackgroundColor:[UIColor colorWithWhite:0.22 alpha:1.0]];
		[passcodeConfirmButton setHighlightEnabled:YES];
		[passcodeConfirmButton.titleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:18]];
		[passcodeConfirmButton.titleLabel setTextColor:[UIColor whiteColor]];
		[passcodeConfirmButton setTitle:@"OK"];
		[passcodeConfirmButton addTarget:self action:@selector(attemptUnlock)];
		[passcodeConfirmButton setUserInteractionEnabled:NO];
		[passcodeConfirmButton setAlpha:0.4];
		[self addSubview:passcodeConfirmButton];
	}
	
	return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return currentPasscodeType == RSPasscodeKeyboardTypeAlphanumeric;
}

- (void)handlePasscodeTextChanged {
	//[passcodeTextField setText:[[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcode]];
	NSString* passcodeText = [[[[[RSCore sharedInstance] lockScreenController] securityController] currentLockView] passcode];
	[passcodeTextField setText:passcodeText];
}

- (void)handleFailedAuthentication {
	[self resetPasscodeText];
	[passcodeTextField showInvalidPIN];
}

- (void)handleFailedMesaAuthentication {
	[self resetPasscodeText];
	[passcodeTextField showInvalidMesa];
}

- (void)setKeypadForPasscodeType:(RSPasscodeKeyboardType)passcodeType {
	currentPasscodeType = passcodeType;
	
	[[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	if (passcodeType == RSPasscodeKeyboardTypeNone) {
		[self setHidden:YES];
	} else if (passcodeType == RSPasscodeKeyboardTypeDigits || passcodeType == RSPasscodeKeyboardTypeDigitsWithConfirm) {
		[self setHidden:NO];
		
		NSString* passcodeLabels = @"123456789 0<";
	
		CGFloat buttonWidth = (self.bounds.size.width - ([RSMetrics tileBorderSpacing] * 2)) / 3;
		CGFloat buttonHeight = (self.bounds.size.width - ([RSMetrics tileBorderSpacing] * 5)) / 6;
		
		for (int i=0; i<4; i++) {
			for (int j=0; j<3; j++) {
				int index = ((i * 3) + (j + 1)) - 1;
				
				if (![[passcodeLabels substringWithRange:NSMakeRange(index, 1)] isEqualToString:@" "]) {
					RSLockScreenPasscodeEntryButton* testView = [[RSLockScreenPasscodeEntryButton alloc] initWithFrame:CGRectMake((buttonWidth + [RSMetrics tileBorderSpacing]) * j,
																				55 + [RSMetrics tileBorderSpacing] + (buttonHeight + [RSMetrics tileBorderSpacing]) * i, buttonWidth, buttonHeight)];
					
					if (![[passcodeLabels substringWithRange:NSMakeRange(index, 1)] isEqualToString:@"<"]) {
						[testView setTitle:[passcodeLabels substringWithRange:NSMakeRange(index, 1)]];
						[testView setNumberPadButton:nil];
						[testView setNumberPadButton:[objc_getClass("SBUIPasscodeLockNumberPad") _buttonForCharacter:index withLightStyle:NO]];
						
					} else {
						[testView setIsBackspaceButton:YES];
						[testView.titleLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:34]];
						[testView setTitle:@"\uE94F"];
					}
					[self addSubview:testView];
				}
			}
		}
	
		if (passcodeType == RSPasscodeKeyboardTypeDigits) {
			[passcodeTextField setFrame:CGRectMake(0, 0, self.frame.size.width, 55)];
			[passcodeConfirmButton setHidden:YES];
		} else if (passcodeType == RSPasscodeKeyboardTypeDigitsWithConfirm) {
			[passcodeTextField setFrame:CGRectMake(20, 0, self.frame.size.width - buttonHeight - [RSMetrics tileBorderSpacing] - 20, 55)];
		
			[passcodeConfirmButton setHidden:NO];
			[passcodeConfirmButton setFrame:CGRectMake(passcodeTextField.frame.size.width + [RSMetrics tileBorderSpacing], 0, buttonHeight, 55)];
			[passcodeConfirmButton.titleLabel setFrame:CGRectMake(0, 0, buttonHeight, 55)];
			[self addSubview:passcodeConfirmButton];
		}
	}
	
	[self addSubview:passcodeTextField];
}

- (void)resetPasscodeText {
	[passcodeTextField setText:nil];
	[passcodeTextField setTextAlignment:NSTextAlignmentCenter];
	[passcodeConfirmButton setUserInteractionEnabled:NO];
	[passcodeConfirmButton setAlpha:0.4];
}

- (void)addTextToPasscode:(NSString*)text {
	[passcodeTextField setText:[passcodeTextField.text stringByAppendingString:text]];
	
	if (passcodeTextField.text.length >= 1) {
		[passcodeConfirmButton setUserInteractionEnabled:YES];
		[passcodeConfirmButton setAlpha:1.0];
	}
	
	if (currentPasscodeType == RSPasscodeKeyboardTypeDigitsWithConfirm || currentPasscodeType == RSPasscodeKeyboardTypeAlphanumeric) {
		[passcodeTextField setTextAlignment:NSTextAlignmentLeft];
	}
}

- (void)removeCharacter {
	if (passcodeTextField.text.length > 0) {
		[passcodeTextField setText:[passcodeTextField.text substringToIndex:passcodeTextField.text.length-1]];
		
		if (passcodeTextField.text.length < 1) {
			[passcodeConfirmButton setUserInteractionEnabled:NO];
			[passcodeConfirmButton setAlpha:0.4];
		}
		[passcodeTextField setTextAlignment:NSTextAlignmentCenter];
	}
}

- (void)attemptUnlock {
	[(SBLockScreenManager*)[objc_getClass("SBLockScreenManager") sharedInstance] attemptUnlockWithPasscode:passcodeTextField.text];
}

@end
