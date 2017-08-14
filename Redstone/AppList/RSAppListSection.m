#import "Redstone.h"

@implementation RSAppListSection

- (id)initWithFrame:(CGRect)frame letter:(NSString*)letter {
	if (self = [super initWithFrame:frame]) {
		displayName = letter;
		self.originalCenter = self.center;
		
		[self setHighlightEnabled:YES];
		
		sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 60, 60)];
		[sectionLabel setFont:[UIFont fontWithName:@"SegoeUI-Light" size:30]];
		[sectionLabel setTextColor:[UIColor whiteColor]];
		
		if ([letter isEqualToString:@"@"]) {
			[sectionLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:24]];
			[sectionLabel setText:@"\uE12B"];
		} else {
			[sectionLabel setText:letter];
		}
		[self addSubview:sectionLabel];
		
		UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:tapGestureRecognizer];
	}
	
	return self;
}

- (void)tapped:(UITapGestureRecognizer*)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		[self untilt];
		[[[[RSCore sharedInstance] homeScreenController] appListController] showJumpList];
	}
}

- (NSString*)displayName {
	return displayName;
}

@end
