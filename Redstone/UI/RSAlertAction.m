#import "Redstone.h"

@implementation RSAlertAction

+ (id)actionWithTitle:(NSString *)title handler:(void (^)(void))handler {
	RSAlertAction* action = [[RSAlertAction alloc] initWithFrame:CGRectZero];
	[action.titleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:17]];
	[action.titleLabel setTextColor:[UIColor whiteColor]];
	[action setTitle:title];
	[action setHighlightEnabled:YES];
	[action setBackgroundColor:[UIColor colorWithWhite:0.38 alpha:1.0]];
	
	action.handler = handler;
	
	return action;
}

@end
