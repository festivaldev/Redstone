#import "../Redstone.h"

@implementation RSTile

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString *)bundleIdentifier {
	if (self = [super initWithFrame:frame]) {
		self.size = size;
		self.icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier];
		self.originalCenter = self.center;
		
		tileLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, frame.size.height-28, frame.size.width-16, 20)];
		[tileLabel setFont:[UIFont fontWithName:@"SegoeUI" size:14]];
		[tileLabel setTextAlignment:NSTextAlignmentLeft];
		[tileLabel setTextColor:[UIColor whiteColor]];
		[tileLabel setText:[self.icon displayName]];
		[self addSubview:tileLabel];
		
		if (self.size < 2) {
			[tileLabel setHidden:YES];
		}
		
		longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
		[longPressGestureRecognizer setMinimumPressDuration:0.5];
		[longPressGestureRecognizer setCancelsTouchesInView:NO];
		[longPressGestureRecognizer setDelaysTouchesBegan:NO];
		[self addGestureRecognizer:longPressGestureRecognizer];
		
		panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoved:)];
		[panGestureRecognizer setDelegate:self];
		[panGestureRecognizer setCancelsTouchesInView:NO];
		[panGestureRecognizer setDelaysTouchesBegan:NO];
		[self addGestureRecognizer:panGestureRecognizer];
		
		tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
		[tapGestureRecognizer setCancelsTouchesInView:NO];
		[tapGestureRecognizer setDelaysTouchesBegan:NO];
		[tapGestureRecognizer requireGestureRecognizerToFail:panGestureRecognizer];
		[tapGestureRecognizer requireGestureRecognizerToFail:longPressGestureRecognizer];
		[self addGestureRecognizer:tapGestureRecognizer];
	}
	
	return self;
}

- (CGRect)basePosition {
	return CGRectMake(self.center.x - (self.bounds.size.width/2),
					  self.center.y - (self.bounds.size.height/2),
					  self.bounds.size.width,
					  self.bounds.size.height);
}

#pragma mark Gesture Recognizers

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

- (void)pressed:(UILongPressGestureRecognizer*)sender {
	panEnabled = NO;
	
	if (![[[[RSCore sharedInstance] homeScreenController] startScreenController] isEditing]) {
		[longPressGestureRecognizer setEnabled:NO];
		
		[tapGestureRecognizer setEnabled:NO];
		[tapGestureRecognizer setEnabled:YES];
		
		[[[[RSCore sharedInstance] homeScreenController] startScreenController] setIsEditing:YES];
		[[[[RSCore sharedInstance] homeScreenController] startScreenController] setSelectedTile:self];
	}
}

- (void)panMoved:(UIPanGestureRecognizer*)sender {
	CGPoint touchLocation = [sender locationInView:self.superview];
	
	if (sender.state == UIGestureRecognizerStateBegan) {
		[[[[RSCore sharedInstance] homeScreenController] startScreenController] setSelectedTile:self];
		
		CGPoint relativePosition = [self.superview convertPoint:self.center toView:self.superview];
		centerOffset = CGPointMake(relativePosition.x - touchLocation.x, relativePosition.y - touchLocation.y);
	}
	
	if (sender.state == UIGestureRecognizerStateChanged && panEnabled) {
		self.center = CGPointMake(touchLocation.x + centerOffset.x, touchLocation.y + centerOffset.y);
	}
	
	if (sender.state == UIGestureRecognizerStateEnded && panEnabled) {
		centerOffset = CGPointZero;
		
		[[[[RSCore sharedInstance] homeScreenController] startScreenController] snapTile:self withTouchPosition:self.center];
	}
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

#pragma mark Editing Mode

- (void)setIsSelectedTile:(BOOL)isSelectedTile {
	if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] isEditing]) {
		_isSelectedTile = isSelectedTile;
		
		if (isSelectedTile) {
			panEnabled = YES;

			[[RSCore.sharedInstance homeScreenController].startScreenController.view.panGestureRecognizer setEnabled:NO];
			[[RSCore.sharedInstance homeScreenController].startScreenController.view.panGestureRecognizer setEnabled:YES];
			
			[self.superview bringSubviewToFront:self];
			[self setAlpha:1.0];
			[self setTransform:CGAffineTransformMakeScale(1.05, 1.05)];
		} else {
			panEnabled = NO;
			
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
		panEnabled = NO;
		
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
