#import "Redstone.h"

@implementation RSPasscodeLockViewLongNumericKeypad

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		CGFloat buttonWidth = (frame.size.width - ([RSMetrics tileBorderSpacing] * 4)) / 3;
		CGFloat buttonHeight = (frame.size.width - ([RSMetrics tileBorderSpacing] * 5)) / 6;
		
		passcodeTextField = [[RSLockScreenPasscodeEntryTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - buttonHeight - [RSMetrics tileBorderSpacing], 60)];
		[self addSubview:passcodeTextField];
		
		passcodeConfirmButton = [[RSTiltView alloc] initWithFrame:CGRectMake(passcodeTextField.frame.origin.x + passcodeTextField.frame.size.width + [RSMetrics tileBorderSpacing], 0, buttonHeight, 60)];
		[passcodeConfirmButton setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"backgroundColor"]];
		[passcodeConfirmButton setHighlightEnabled:YES];
		[passcodeConfirmButton.titleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:18]];
		[passcodeConfirmButton.titleLabel setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
		[passcodeConfirmButton setTitle:@"OK"];
		[passcodeConfirmButton addTarget:[[objc_getClass("SBUIPasscodeLockViewBase") currentPasscodeView] _longNumericEntryField] action:@selector(_okButtonHit)];
		[self addSubview:passcodeConfirmButton];
		
		NSString* passcodeLabels = @"123456789 0<";
		
		for (int i=0; i<4; i++) {
			for (int j=0; j<3; j++) {
				int index = ((i * 3) + (j + 1)) - 1;
				
				if (![[passcodeLabels substringWithRange:NSMakeRange(index, 1)] isEqualToString:@" "]) {
					CGRect buttonFrame = CGRectMake([RSMetrics tileBorderSpacing] + ((buttonWidth + [RSMetrics tileBorderSpacing]) * j),
													60 + [RSMetrics tileBorderSpacing] + ((buttonHeight + [RSMetrics tileBorderSpacing]) * i),
													buttonWidth,
													buttonHeight);
					RSLockScreenPasscodeEntryButton* testView = [[RSLockScreenPasscodeEntryButton alloc] initWithFrame:buttonFrame];
					
					if (![[passcodeLabels substringWithRange:NSMakeRange(index, 1)] isEqualToString:@"<"]) {
						[testView setTitle:[passcodeLabels substringWithRange:NSMakeRange(index, 1)]];
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
	}
	
	return self;
}

- (void)setPasscodeText:(NSString*)passcodeText {
	[passcodeTextField setText:passcodeText];
}

- (RSPasscodeLockViewType)passcodeLockViewType {
	return RSPasscodeLockViewTypeLongNumeric;
}

- (void)handleFailedAuthentication {
	[passcodeTextField showInvalidPIN];
}

@end
