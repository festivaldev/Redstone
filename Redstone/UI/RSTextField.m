#import "Redstone.h"

@implementation RSTextField

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setDelegate:self];
		
		[self setBackgroundColor:[UIColor blackColor]];
		[self setFont:[UIFont fontWithName:@"SegoeUI" size:17]];
		[self setTextColor:[UIColor whiteColor]];
		
		[self.layer setBorderWidth:2];
		[self.layer setBorderColor:[UIColor colorWithWhite:0.46 alpha:1.0].CGColor];
		
		[self setReturnKeyType:UIReturnKeySearch];
		[self setKeyboardAppearance:UIKeyboardAppearanceDark];
		[self setAutocorrectionType:UITextAutocorrectionTypeNo];
		[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	}
	
	return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
	[self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1.0] }]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self.layer setBorderColor:[RSAesthetics accentColor].CGColor];
	[self setBackgroundColor:[UIColor whiteColor]];
	[self setTextColor:[UIColor blackColor]];
	
	//[clearButton.titleLabel setTextColor:[RSAesthetics colorsForCurrentTheme][@"TextFieldPlaceholderColor"]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self.layer setBorderColor:[UIColor colorWithWhite:0.46 alpha:1.0].CGColor];
	[self setBackgroundColor:[UIColor blackColor]];
	[self setTextColor:[UIColor whiteColor]];
	
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
