#import "Redstone.h"

@implementation RSStartScreenScrollView

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setClipsToBounds:NO];
		[self setContentInset:UIEdgeInsetsMake(24, 0, 70, 0)];
		[self setContentOffset:CGPointMake(0, -24)];
		[self setShowsVerticalScrollIndicator:NO];
		[self setShowsHorizontalScrollIndicator:NO];
		
		wallpaperLegibilitySettings = [[objc_getClass("SBWallpaperController") sharedInstance] legibilitySettingsForVariant:1];
		
		self.allAppsButton = [[RSTiltView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 60)];
		[self.allAppsButton.titleLabel setFont:[UIFont fontWithName:@"SegoeUI" size:18]];
		[self.allAppsButton.titleLabel setTextColor:[wallpaperLegibilitySettings primaryColor]];
		[self.allAppsButton setHighlightEnabled:YES];
		
		NSString* labelText = [NSString stringWithFormat:@"%@\t\uE0AD", [RSAesthetics localizedStringForKey:@"ALL_APPS"]];
		NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:labelText];
		
		[string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SegoeMDL2Assets" size:18] range:[labelText rangeOfString:@"\uE0AD"]];
		[string addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-3.0] range:[labelText rangeOfString:@"\uE0AD"]];
		[self.allAppsButton setAttributedTitle:string];
		
		[self.allAppsButton.titleLabel setTextAlignment:NSTextAlignmentRight];
		[self.allAppsButton addTarget:[^{
			[[[RSCore sharedInstance] homeScreenController] setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
		} copy] action:@selector(invoke)];
		
		[self addSubview:self.allAppsButton];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wallpaperChanged) name:@"RedstoneWallpaperChanged" object:nil];
	}
	
	return self;
}

- (void)wallpaperChanged {
	wallpaperLegibilitySettings = [[objc_getClass("SBWallpaperController") sharedInstance] legibilitySettingsForVariant:1];
	
	[self.allAppsButton.titleLabel setTextColor:[wallpaperLegibilitySettings primaryColor]];
	[self.allAppsButton setHighlightEnabled:YES];
	
	NSString* labelText = [NSString stringWithFormat:@"%@\t\uE0AD", [RSAesthetics localizedStringForKey:@"ALL_APPS"]];
	NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:labelText];
	
	[string addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-3.0] range:[labelText rangeOfString:@"\uE0AD"]];
	[self.allAppsButton setAttributedTitle:string];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	if (CGRectContainsPoint(self.frame, point) || [[[[RSCore sharedInstance] homeScreenController] startScreenController] isEditing]) {
		return YES;
	}
	
	return [super pointInside:point withEvent:event];
}

- (void)setContentSize:(CGSize)contentSize {
	[super setContentSize:contentSize];
	[self.allAppsButton setFrame:CGRectMake(0,
											contentSize.height + [RSMetrics tileBorderSpacing],
											self.bounds.size.width,
											60)];
}

@end
