#import "Redstone.h"

@implementation RSTextField

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setDelegate:self];
		
		[self setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"textFieldBackgroundColor"]];
		[self setFont:[UIFont fontWithName:@"SegoeUI" size:17]];
		[self setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
		
		[self.layer setBorderWidth:2];
		[self.layer setBorderColor:[RSAesthetics colorForCurrentThemeByCategory:@"borderColor"].CGColor];
		
		[self setReturnKeyType:UIReturnKeySearch];
		[self setKeyboardAppearance:UIKeyboardAppearanceDark];
		[self setAutocorrectionType:UITextAutocorrectionTypeNo];
		[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	}
	
	return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
	NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:placeholder];
	[attributedString addAttribute:NSForegroundColorAttributeName value:[RSAesthetics colorForCurrentThemeByCategory:@"textFieldPlaceholderColor"] range:NSMakeRange(0, placeholder.length)];
	[self setAttributedPlaceholder:attributedString];
}

- (void)accentColorChanged {
	if (!self.isFirstResponder) {
		[self setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"textFieldBackgroundColor"]];
		[self setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
		[self.layer setBorderColor:[RSAesthetics colorForCurrentThemeByCategory:@"borderColor"].CGColor];
		
		NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
		[attributedString addAttribute:NSForegroundColorAttributeName value:[RSAesthetics colorForCurrentThemeByCategory:@"textFieldPlaceholderColor"] range:NSMakeRange(0, self.placeholder.length)];
		[self setAttributedPlaceholder:attributedString];


	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self.layer setBorderColor:[RSAesthetics accentColor].CGColor];
	[self setBackgroundColor:[UIColor whiteColor]];
	[self setTextColor:[UIColor blackColor]];
	
	//[clearButton.titleLabel setTextColor:[RSAesthetics colorsForCurrentTheme][@"TextFieldPlaceholderColor"]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"textFieldBackgroundColor"]];
	[self setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
	[self.layer setBorderColor:[RSAesthetics colorForCurrentThemeByCategory:@"borderColor"].CGColor];
	
	//[clearButton.titleLabel setTextColor:[[RSAesthetics colorsForCurrentTheme][@"TextFieldPlaceholderColor"] colorWithAlphaComponent:0.4]];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, 12, 6);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return CGRectInset(bounds, 12, 6);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	
	[textField resignFirstResponder];
	return YES;
}

@end
