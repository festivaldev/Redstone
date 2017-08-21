#import "Redstone.h"

@implementation RSTiltView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self.layer setShouldRasterize:YES];
		[self.layer setRasterizationScale:[UIScreen mainScreen].scale];
		[self.layer setContentsScale:[UIScreen mainScreen].scale];
		[self.layer setAllowsEdgeAntialiasing:YES];
		
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[self.titleLabel setTextAlignment:NSTextAlignmentCenter];
		
		highlightLayer = [CALayer new];
		[highlightLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[highlightLayer setOpacity:0];
		[self.layer addSublayer:highlightLayer];
		
		[self setTiltEnabled:YES];
		tiltGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
		[tiltGestureRecognizer setCancelsTouchesInView:NO];
		[tiltGestureRecognizer setDelaysTouchesEnded:NO];
		[tiltGestureRecognizer setDelaysTouchesBegan:YES];
		[tiltGestureRecognizer setMinimumPressDuration:0];
		[tiltGestureRecognizer setDelegate:self];
		[tiltGestureRecognizer setAllowableMovement:1.0];
		[self addGestureRecognizer:tiltGestureRecognizer];
	}
	
	return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	
	return YES;
}

- (void)handleGesture:(UILongPressGestureRecognizer*)sender {
	switch (sender.state) {
		case UIGestureRecognizerStateBegan:
			if (self.tiltEnabled) {
				[self setTransformForPosition:[sender locationInView:self]];
			}
			
			if (self.highlightEnabled) {
				[CATransaction begin];
				[CATransaction setDisableActions:YES];
				
				isHighlighted = YES;
				if (self.coloredHighlight) {
					[highlightLayer setBackgroundColor:[RSAesthetics accentColor].CGColor];
				} else {
					[highlightLayer setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor];
				}
				[highlightLayer setOpacity:1.0];
			
				[CATransaction commit];
			}
			break;
		case UIGestureRecognizerStateEnded:
		case UIGestureRecognizerStateCancelled:
			[self untilt];
			break;
		default: break;
	}
}

- (void)setTransformForPosition:(CGPoint)position {
	[self.layer removeAllAnimations];
	
	float width = self.bounds.size.width, height = self.bounds.size.height;
	float x = position.x, y = position.y;
	
	float transformX = 0, transformY = 0, transformOrigX = 0, transformOrigY = 0;
	
	if (x>=0 && x <= width && y >= 0 && y <= height) {
		float angle = 11;
		
		CATransform3D rotateX = CATransform3DIdentity;
		CATransform3D rotateY = CATransform3DIdentity;
		
		// Set actual transform
		if (x<=(width/3)) {
			transformY = -1;
			transformOrigX = 1;
		} else if (x<=(width/3)*2 && x>(width/3)) {
			transformY = 0;
			transformOrigX = 0.5;
		} else if (x<=width && x>(width/3)*2) {
			transformY = 1;
			transformOrigX = 0;
		}
		
		if (y<=(height/3)) {
			transformX = 1;
			transformOrigY = 1;
		} else if (y<=(height/3)*2 && y>(height/3)) {
			transformX = 0;
			transformOrigY = 0.5;
		} else if (y<=height && y>(height/3)*2) {
			transformX = -1;
			transformOrigY = 0;
		}
		
		rotateX = CATransform3DRotate (self.layer.transform, deg2rad(angle), 0, transformY, 0 );
		rotateY = CATransform3DRotate(self.layer.transform, deg2rad(angle), transformX, 0, 0 );
		
		CATransform3D finalTransform;
		finalTransform.m34 = -1 / 2000;
		
		if (x<=(width/3)*2 && x>(width/3) && y<=(height/3)*2 && y>(height/3)) {
			transformOrigX = 0.5;
			transformOrigY = 0.5;
			finalTransform = CATransform3DScale(self.layer.transform, 0.970, 0.97, 1);
		} else {
			finalTransform = CATransform3DConcat(rotateX, rotateY);
		}
		
		[self.layer setTransform:finalTransform];
		isTilted = YES;
	}
}

- (void)untilt {
	if (!self.tiltEnabled && !self.highlightEnabled) {
		return;
	}
	
	[self.layer removeAllAnimations];
	
	if (isTilted || isHighlighted) {
		[UIView animateWithDuration:.15 animations:^{
			if (self.tiltEnabled && isTilted) {
				[self.layer setTransform:CATransform3DIdentity];
			}
			
			if (self.highlightEnabled && isHighlighted) {
				[highlightLayer setOpacity:0.0];
			}
		} completion:^(BOOL finished) {
			isTilted = NO;
			isHighlighted = NO;
		}];
	} else {
		[self.layer setTransform:CATransform3DIdentity];
	}
	
	isTilted = NO;
	isHighlighted = NO;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	NSLog(@"[Redstone] cancelling touch");
	[self untilt];
}

- (void)setTiltEnabled:(BOOL)tiltEnabled {
	_tiltEnabled = tiltEnabled;
	
	if (!tiltEnabled && isTilted) {
		[self untilt];
	}
}

- (void)setHighlightEnabled:(BOOL)highlightEnabled {
	_highlightEnabled = highlightEnabled;
	
	if (!highlightEnabled && isHighlighted) {
		[self untilt];
	}
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[highlightLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)addTarget:(id)target action:(SEL)action {
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
	[self addGestureRecognizer:tap];
}

- (void)setTitle:(NSString*)title {
	if (title) {
		[self addSubview:self.titleLabel];
	} else {
		[self.titleLabel removeFromSuperview];
	}
	
	[self.titleLabel setText:title];
}

- (void)setAttributedTitle:(NSAttributedString*)attributedTitle {
	if (attributedTitle) {
		[self addSubview:self.titleLabel];
	} else {
		[self.titleLabel removeFromSuperview];
	}
	
	[self.titleLabel setAttributedText:attributedTitle];
}

/*- (void)untilt {
	if (!self.tiltEnabled && !self.highlightEnabled) {
		return;
	}
	
	if (isTilted || isHighlighted) {
		[UIView animateWithDuration:.15 animations:^{
			if (self.tiltEnabled && isTilted) {
				[self.layer setTransform:CATransform3DIdentity];
			}
			
			if (self.highlightEnabled && isHighlighted) {
				[highlightLayer setOpacity:0.0];
			}
		} completion:^(BOOL finished) {
			isTilted = NO;
			isHighlighted = NO;
		}];
	} else {
		[self.layer setTransform:CATransform3DIdentity];
	}
	
	isTilted = NO;
	isHighlighted = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	
	if (self.tiltEnabled) {
		[self.layer removeAllAnimations];
		
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint touchLocation = [touch locationInView:touch.view];
		
		float width = self.bounds.size.width, height = self.bounds.size.height;
		float x = touchLocation.x, y = touchLocation.y;
		
		float transformX = 0, transformY = 0, transformOrigX = 0, transformOrigY = 0;
		
		if (x>=0 && x <= width && y >= 0 && y <= height) {
			float angle = 11;
			
			CATransform3D rotateX = CATransform3DIdentity;
			CATransform3D rotateY = CATransform3DIdentity;
			
			// Set actual transform
			if (x<=(width/3)) {
				transformY = -1;
				transformOrigX = 1;
			} else if (x<=(width/3)*2 && x>(width/3)) {
				transformY = 0;
				transformOrigX = 0.5;
			} else if (x<=width && x>(width/3)*2) {
				transformY = 1;
				transformOrigX = 0;
			}
			
			if (y<=(height/3)) {
				transformX = 1;
				transformOrigY = 1;
			} else if (y<=(height/3)*2 && y>(height/3)) {
				transformX = 0;
				transformOrigY = 0.5;
			} else if (y<=height && y>(height/3)*2) {
				transformX = -1;
				transformOrigY = 0;
			}
			
			rotateX = CATransform3DRotate (self.layer.transform, deg2rad(angle), 0, transformY, 0 );
			rotateY = CATransform3DRotate(self.layer.transform, deg2rad(angle), transformX, 0, 0 );
			
			CATransform3D finalTransform;
			finalTransform.m34 = -1 / 2000;
			
			if (x<=(width/3)*2 && x>(width/3) && y<=(height/3)*2 && y>(height/3)) {
				transformOrigX = 0.5;
				transformOrigY = 0.5;
				finalTransform = CATransform3DScale(self.layer.transform, 0.970, 0.97, 1);
			} else {
				finalTransform = CATransform3DConcat(rotateX, rotateY);
			}
			
			[self.layer setTransform:finalTransform];
			isTilted = YES;
		}
	}
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	
	if (self.highlightEnabled) {
		isHighlighted = YES;
		if (self.coloredHighlight) {
			[highlightLayer setBackgroundColor:[RSAesthetics accentColor].CGColor];
		} else {
			[highlightLayer setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor];
		}
		[highlightLayer setOpacity:1.0];
	}
	
	[CATransaction commit];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	
	[self untilt];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
	
	[self untilt];
}

- (void)setTiltEnabled:(BOOL)tiltEnabled {
	_tiltEnabled = tiltEnabled;
	
	if (!tiltEnabled && isTilted) {
		[self untilt];
	}
}

- (void)setHighlightEnabled:(BOOL)highlightEnabled {
	_highlightEnabled = highlightEnabled;
	
	if (!highlightEnabled && isHighlighted) {
		[self untilt];
	}
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	
	[highlightLayer setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)addTarget:(id)target action:(SEL)action {
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
	[self addGestureRecognizer:tap];
}

- (void)setTitle:(NSString*)title {
	if (title) {
		[self addSubview:self.titleLabel];
	} else {
		[self.titleLabel removeFromSuperview];
	}
	
	[self.titleLabel setText:title];
}*/

@end
