#import "Redstone.h"

@implementation RSAlertAction

+ (id)actionWithTitle:(NSString *)title handler:(void (^)(void))handler {
	RSAlertAction* action = [[RSAlertAction alloc] initWithFrame:CGRectZero];
	[action.titleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:17]];
	[action.titleLabel setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
	[action setTitle:title];
	[action setHighlightEnabled:YES];
	[action setBackgroundColor:[RSAesthetics colorForCurrentThemeByCategory:@"buttonBackgroundColor"]];
	
	action.handler = handler;
	
	return action;
}

@end
