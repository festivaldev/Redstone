#import "Redstone.h"

@implementation RSJumpList

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[[RSAesthetics colorForCurrentThemeByCategory:@"solidBackgroundColor"] colorWithAlphaComponent:0.75]];
		
		CGSize deviceOffset = CGSizeMake(MAX((screenWidth - 320) / 2, 0),
										 MAX((screenHeight - 560) / 2, 0));
		
		alphabetScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[alphabetScrollView setShowsVerticalScrollIndicator:NO];
		[alphabetScrollView setShowsHorizontalScrollIndicator:NO];
		[alphabetScrollView setContentSize:CGSizeMake(320, 560)];
		[alphabetScrollView setContentInset:UIEdgeInsetsMake(deviceOffset.height,
															 deviceOffset.width,
															 deviceOffset.height,
															 deviceOffset.width)];
		
		[alphabetScrollView setContentOffset:CGPointMake(-deviceOffset.width, -deviceOffset.height)];
		[self addSubview:alphabetScrollView];
		
		[self setHidden:YES];

	}
	
	return self;
}

- (void)animateIn {
	if (self.isOpen) {
		return;
	}
	
	[[alphabetScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
	
	NSString* alphabet = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ@";
	int sectionTag = 0;
	
	for (int i=0; i<7; i++) {
		for (int j=0; j<4; j++) {
			int index = ((i * 4) + (j + 1)) - 1;
			NSString* letter = [[alphabet substringWithRange:NSMakeRange(index, 1)] uppercaseString];
			
			RSTiltView* jumpListLetter = [[RSTiltView alloc] initWithFrame:CGRectMake(j*80, i*80, 80, 80)];
			[jumpListLetter setHighlightEnabled:YES];
			[alphabetScrollView addSubview:jumpListLetter];
			
			[jumpListLetter.titleLabel setFrame:CGRectMake(0, 0, 80, 80)];
			[jumpListLetter.titleLabel setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"foregroundColor"]];
			[jumpListLetter.titleLabel setTextAlignment:NSTextAlignmentCenter];
			[jumpListLetter.titleLabel setFont:[UIFont fontWithName:@"SegoeUI-Light" size:48]];
			[jumpListLetter addSubview:jumpListLetter.titleLabel];
			
			if ([letter isEqualToString:@"@"]) {
				letter = @"\uE12B";
				
				NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:letter];
				[attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-2.0] range:NSMakeRange(0, 1)];
				
				[jumpListLetter.titleLabel setAttributedText:attributedString];
				[jumpListLetter.titleLabel setFont:[UIFont fontWithName:@"SegoeUI-Light" size:40]];
			} else {
				[jumpListLetter.titleLabel setText:letter];
			}
			
			if ([[[[RSCore sharedInstance] homeScreenController] appListController] sectionWithLetter:letter] != nil) {
				UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToLetter:)];
				[tapGestureRecognizer setCancelsTouchesInView:NO];
				[jumpListLetter addGestureRecognizer:tapGestureRecognizer];
			} else {
				[jumpListLetter setUserInteractionEnabled:NO];
				[jumpListLetter.titleLabel setTextColor:[RSAesthetics colorForCurrentThemeByCategory:@"disabledColor"]];
			}
			
			[alphabetScrollView addSubview:jumpListLetter];
			[jumpListLetter setTag:sectionTag];
			sectionTag++;
		}
	}
	
	self.isOpen = YES;
	[self setHidden:NO];
	
	[[[RSCore sharedInstance] homeScreenController] setScrollEnabled:NO];
	
	CGSize deviceOffset = CGSizeMake(MAX((screenWidth - 320) / 2, 0),
									 MAX((screenHeight - 560) / 2, 0));
	[alphabetScrollView setContentInset:UIEdgeInsetsMake(deviceOffset.height,
														 deviceOffset.width,
														 deviceOffset.height,
														 deviceOffset.width)];
	[alphabetScrollView setContentOffset:CGPointMake(-deviceOffset.width, -deviceOffset.height)];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:CubicEaseOut
														 fromValue:1.2
														   toValue:1.0];
	[scale setDuration:0.4];
	[scale setRemovedOnCompletion:NO];
	[scale setFillMode:kCAFillModeForwards];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseOut
														   fromValue:0.0
															 toValue:1.0];
	[opacity setDuration:0.25];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	
	[self.layer addAnimation:scale forKey:@"scale"];
	[self.layer addAnimation:opacity forKey:@"opacity"];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[alphabetScrollView setUserInteractionEnabled:YES];
	});
}

- (void)animateOut {
	if (!self.isOpen) {
		return;
	}
	
	self.isOpen = NO;
	
	[alphabetScrollView setUserInteractionEnabled:NO];
	
	CAAnimation* opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"
															function:CubicEaseIn
														   fromValue:1.0
															 toValue:0.0];
	[opacity setDuration:0.2];
	[opacity setRemovedOnCompletion:NO];
	[opacity setFillMode:kCAFillModeForwards];
	
	CAAnimation* scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"
														  function:CubicEaseIn
														 fromValue:1.0
														   toValue:1.2];
	[scale setDuration:0.225];
	[scale setRemovedOnCompletion:NO];
	[scale setFillMode:kCAFillModeForwards];
	
	[self.layer addAnimation:scale forKey:@"scale"];
	[self.layer addAnimation:opacity forKey:@"opacity"];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setHidden:YES];
		[[[RSCore sharedInstance] homeScreenController] setScrollEnabled:YES];
	});
}

- (void)jumpToLetter:(UITapGestureRecognizer*)gestureRecognizer {
	NSString* alphabet = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ@";
	NSString* letter = [alphabet substringWithRange:NSMakeRange(gestureRecognizer.view.tag, 1)];
	
	[[[[RSCore sharedInstance] homeScreenController] appListController] jumpToSectionWithLetter:letter];
	[self animateOut];
}

- (void)accentColorChanged {
	[self setBackgroundColor:[[RSAesthetics colorForCurrentThemeByCategory:@"solidBackgroundColor"] colorWithAlphaComponent:0.75]];
}

@end
