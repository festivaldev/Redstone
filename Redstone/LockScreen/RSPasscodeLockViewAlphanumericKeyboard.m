#import "Redstone.h"

@implementation RSPasscodeLockViewAlphanumericKeyboard

- (id)initWithFrame:(CGRect)frame passcodeKeyboard:(SBPasscodeKeyboard*)passcodeKeyboard {
	if (self = [super initWithFrame:frame]) {
		passcodeTextField = [[RSLockScreenPasscodeEntryTextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
		[self addSubview:passcodeTextField];
		
		[self setBackgroundColor:[UIColor colorWithWhite:0.22 alpha:1.0]];
		[self addSubview:passcodeKeyboard];
	}
	
	return self;
}

- (void)setPasscodeText:(NSString*)passcodeText {
	[passcodeTextField setText:passcodeText];
}

- (RSPasscodeLockViewType)passcodeLockViewType {
	return RSPasscodeLockViewTypeAlphanumeric;
}

- (void)handleFailedAuthentication {
	[passcodeTextField showInvalidPIN];
}

@end
