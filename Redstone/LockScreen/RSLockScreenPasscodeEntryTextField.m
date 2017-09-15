#import "Redstone.h"

@implementation RSLockScreenPasscodeEntryTextField

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[UIColor clearColor]];
		[self setFont:[UIFont fontWithName:@"SegoeUI" size:28]];
		[self setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
		[self setTextAlignment:NSTextAlignmentCenter];
		[self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[self setSecureTextEntry:YES];
		
		NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[RSAesthetics localizedStringForKey:@"PASSCODE_ENTER_PIN"]];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"] range:NSMakeRange(0, attributedString.length)];
		[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SegoeUI" size:18] range:NSMakeRange(0, attributedString.length)];
		[self setAttributedPlaceholder:attributedString];
	}
	
	return self;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, 20, 12);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, 20, 6);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, 20, 6);
}

- (void)showInvalidPIN {
	[self setBackgroundColor:[RSAesthetics accentColor]];
	[self.superview setUserInteractionEnabled:NO];
	
	NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[RSAesthetics localizedStringForKey:@"PASSCODE_INVALID_PIN"]];
	[attributedString addAttribute:NSForegroundColorAttributeName value:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"] range:NSMakeRange(0, attributedString.length)];
	[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SegoeUI" size:18] range:NSMakeRange(0, attributedString.length)];
	[self setAttributedPlaceholder:attributedString];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setBackgroundColor:[UIColor clearColor]];
		[self.superview setUserInteractionEnabled:YES];
		
		NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:[RSAesthetics localizedStringForKey:@"PASSCODE_ENTER_PIN"]];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"] range:NSMakeRange(0, attributedString.length)];
		[attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SegoeUI" size:18] range:NSMakeRange(0, attributedString.length)];
		[self setAttributedPlaceholder:attributedString];
	});
}

@end
