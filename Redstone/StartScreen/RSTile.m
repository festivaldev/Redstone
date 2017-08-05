#import "../Redstone.h"

@implementation RSTile

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString *)bundleIdentifier {
	if (self = [super initWithFrame:frame]) {
		self.size = size;
		self.icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier];
		
		tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[self addGestureRecognizer:tapGestureRecognizer];
		
		longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
		[self addGestureRecognizer:longPressGestureRecognizer];
	}
	
	return self;
}

- (void)tapped:(UITapGestureRecognizer*)sender {
	if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] isEditing]) {
		if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] selectedTile] == self) {
			[[[[RSCore sharedInstance] homeScreenController] startScreenController] setIsEditing:NO];
		} else {
			[[[[RSCore sharedInstance] homeScreenController] startScreenController] setSelectedTile:self];
		}
	} else {
		[[objc_getClass("SBIconController") sharedInstance] _launchIcon:self.icon];
	}
}

- (void)pressed:(UILongPressGestureRecognizer*)sender {
	[longPressGestureRecognizer setEnabled:NO];
	[[[[RSCore sharedInstance] homeScreenController] startScreenController] setIsEditing:YES];
	[[[[RSCore sharedInstance] homeScreenController] startScreenController] setSelectedTile:self];
}

- (void)setIsSelectedTile:(BOOL)isSelectedTile {
	if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] isEditing]) {
		_isSelectedTile = isSelectedTile;
		
		if (isSelectedTile) {
			[self.superview bringSubviewToFront:self];
			[self setAlpha:1.0];
			[self setTransform:CGAffineTransformMakeScale(1.05, 1.05)];
		} else {
			[UIView animateWithDuration:.2 animations:^{
				[self setEasingFunction:easeOutQuint forKeyPath:@"frame"];
				
				[self setAlpha:0.8];
				[self setTransform:CGAffineTransformMakeScale(0.85, 0.85)];
			} completion:^(BOOL finished) {
				[self removeEasingFunctionForKeyPath:@"frame"];
			}];
		}
	} else {
		_isSelectedTile = NO;
		
		[UIView animateWithDuration:.2 animations:^{
			[self setEasingFunction:easeOutQuint forKeyPath:@"frame"];
			
			[self setAlpha:1.0];
			[self setTransform:CGAffineTransformIdentity];
		} completion:^(BOOL finished) {
			[self removeEasingFunctionForKeyPath:@"frame"];
		}];
		
		[longPressGestureRecognizer setEnabled:YES];
	}
}

@end
