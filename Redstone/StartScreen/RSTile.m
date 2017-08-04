#import "../Redstone.h"

@implementation RSTile

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString *)bundleIdentifier {
	if (self = [super initWithFrame:frame]) {
		self.size = size;
		self.icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier];
		
		UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:tapGestureRecognizer];
	}
	
	return self;
}

- (void)tapped:(UITapGestureRecognizer*)sender {
	[[objc_getClass("SBIconController") sharedInstance] _launchIcon:self.icon];
}

@end
