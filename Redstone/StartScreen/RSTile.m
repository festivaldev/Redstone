#import "../Redstone.h"

@implementation RSTile

- (id)initWithFrame:(CGRect)frame size:(int)size bundleIdentifier:(NSString *)bundleIdentifier {
	if (self = [super initWithFrame:frame]) {
		self.size = size;
		self.icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:bundleIdentifier];
		self.originalCenter = self.center;
		
		[self setBackgroundColor:[UIColor colorWithRed:0.0 green:0.47 blue:0.84 alpha:0.8]];
		
		// Tile Label
		
		tileLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, frame.size.height-28, frame.size.width-16, 20)];
		[tileLabel setFont:[UIFont fontWithName:@"SegoeUI" size:14]];
		[tileLabel setTextAlignment:NSTextAlignmentLeft];
		[tileLabel setTextColor:[UIColor whiteColor]];
		[tileLabel setText:[self.icon displayName]];
		[self addSubview:tileLabel];
		
		if (self.size < 2) {
			[tileLabel setHidden:YES];
		}
		
		// Gesture Recognizers
		
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
		
		// Editing Mode Buttons
		
		unpinButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		[unpinButton setCenter:CGPointMake(frame.size.width, 0)];
		[unpinButton setBackgroundColor:[UIColor whiteColor]];
		[unpinButton.layer setCornerRadius:15];
		[unpinButton setHidden:YES];
		[self addSubview:unpinButton];
		
		UILabel* unpinButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		[unpinButtonLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:14]];
		[unpinButtonLabel setText:@"\uE77A"];
		[unpinButtonLabel setTextColor:[UIColor blackColor]];
		[unpinButtonLabel setTextAlignment:NSTextAlignmentCenter];
		[unpinButton addSubview:unpinButtonLabel];
		
		unpinGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(unpin)];
		[unpinButton addGestureRecognizer:unpinGestureRecognizer];
		
		resizeButton = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		[resizeButton setCenter:CGPointMake(frame.size.width, frame.size.height)];
		[resizeButton setBackgroundColor:[UIColor whiteColor]];
		[resizeButton.layer setCornerRadius:15];
		[resizeButton setTransform:CGAffineTransformMakeRotation(deg2rad([self scaleButtonRotationForCurrentSize]))];
		[resizeButton setHidden:YES];
		[self addSubview:resizeButton];
		
		UILabel* resizeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		[resizeButtonLabel setFont:[UIFont fontWithName:@"SegoeMDL2Assets" size:14]];
		[resizeButtonLabel setText:@"\uE7EA"];
		[resizeButtonLabel setTextColor:[UIColor blackColor]];
		[resizeButtonLabel setTextAlignment:NSTextAlignmentCenter];
		[resizeButton addSubview:resizeButtonLabel];
		
		resizeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setNextSize)];
		[resizeButton addGestureRecognizer:resizeGestureRecognizer];
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
		
		[unpinButton setHidden:YES];
		[resizeButton setHidden:YES];
	}
	
	if (sender.state == UIGestureRecognizerStateChanged && panEnabled) {
		self.center = CGPointMake(touchLocation.x + centerOffset.x, touchLocation.y + centerOffset.y);
	}
	
	if (sender.state == UIGestureRecognizerStateEnded && panEnabled) {
		centerOffset = CGPointZero;
		
		[unpinButton setHidden:NO];
		[resizeButton setHidden:NO];
		
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

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if (self.isSelectedTile) {
		if (CGRectContainsPoint(unpinButton.frame, point)) {
			[tapGestureRecognizer setEnabled:NO];
			[panGestureRecognizer setEnabled:NO];
			
			return unpinButton;
		} else if (CGRectContainsPoint(resizeButton.frame, point)) {
			[tapGestureRecognizer setEnabled:NO];
			[panGestureRecognizer setEnabled:NO];
			
			return resizeButton;
		}
	}
	
	[tapGestureRecognizer setEnabled:YES];
	[panGestureRecognizer setEnabled:YES];
	
	return [super hitTest:point withEvent:event];
}

#pragma mark Editing Mode

- (void)setIsSelectedTile:(BOOL)isSelectedTile {
	if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] isEditing]) {
		_isSelectedTile = isSelectedTile;
		
		if (isSelectedTile) {
			panEnabled = YES;

			[[RSCore.sharedInstance homeScreenController].startScreenController.view.panGestureRecognizer setEnabled:NO];
			[[RSCore.sharedInstance homeScreenController].startScreenController.view.panGestureRecognizer setEnabled:YES];
			
			[unpinButton setHidden:NO];
			[resizeButton setHidden:NO];
			
			[self.superview bringSubviewToFront:self];
			[self setAlpha:1.0];
			[self setTransform:CGAffineTransformMakeScale(1.05, 1.05)];
		} else {
			panEnabled = NO;
			
			[unpinButton setHidden:YES];
			[resizeButton setHidden:YES];
			
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
		
		[unpinButton setHidden:YES];
		[resizeButton setHidden:YES];
		
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

- (void)unpin {
	
}

- (void)setNextSize {
	switch (self.size) {
		case 1:
			self.size = 3;
			break;
		case 2:
			self.size = 1;
			break;
		case 3:
			self.size = 2;
		default: break;
	}
	
	CGSize newTileSize = [RSMetrics tileDimensionsForSize:self.size];
	
	CGFloat step = [RSMetrics tileDimensionsForSize:1].width + [RSMetrics tileBorderSpacing];
	
	CGFloat maxPositionX = self.superview.bounds.size.width - newTileSize.width;
	CGFloat maxPositionY = [(UIScrollView*)self.superview contentSize].height + [RSMetrics tileBorderSpacing];
	
	CGRect newFrame = CGRectMake(MIN(MAX(step * roundf((self.basePosition.origin.x / step)), 0), maxPositionX),
								 MIN(MAX(step * roundf((self.basePosition.origin.y / step)), 0), maxPositionY),
								 newTileSize.width,
								 newTileSize.height);
	
	CGAffineTransform currentTransform = self.transform;
	
	[self setTransform:CGAffineTransformIdentity];
	[self setFrame:newFrame];
	[self setTransform:currentTransform];
	
	if (self.size < 2) {
		[tileLabel setHidden:YES];
	} else {
		[tileLabel setHidden:NO];
		[tileLabel setFrame:CGRectMake(8,
									   newFrame.size.height - tileLabel.frame.size.height - 8,
									   tileLabel.frame.size.width,
									   tileLabel.frame.size.height)];
	}
	
	[unpinButton setCenter:CGPointMake(newFrame.size.width, 0)];
	[resizeButton setCenter:CGPointMake(newFrame.size.width, newFrame.size.height)];
	
	[resizeButton setTransform:CGAffineTransformMakeRotation(deg2rad([self scaleButtonRotationForCurrentSize]))];
	
	[[[[RSCore sharedInstance] homeScreenController] startScreenController] moveAffectedTilesForTile:self];
}

- (CGFloat)scaleButtonRotationForCurrentSize {
	switch (self.size) {
		case 1:
			return -135.0;
			break;
		case 2:
			return 45.0;
			break;
		case 3:
			return 0.0;
			break;
		case 4:
			return 90.0;
		default:
			return 0.0;
			break;
			
	}
}

@end
