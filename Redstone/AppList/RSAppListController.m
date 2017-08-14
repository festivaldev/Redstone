#import "Redstone.h"

@implementation RSAppListController

- (id)init {
	if (self = [super init]) {
		self.view = [[RSAppListScrollView alloc] initWithFrame:CGRectMake(screenWidth, 70, screenWidth, screenHeight - 70)];
		[self.view setDelegate:self];
		
		sectionBackgroundContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
		[sectionBackgroundContainer setClipsToBounds:YES];
		
		sectionBackgroundImage = [[UIImageView alloc] initWithImage:[RSAesthetics homeScreenWallpaper]];
		[sectionBackgroundImage setContentMode:UIViewContentModeScaleAspectFill];
		[sectionBackgroundImage setFrame:CGRectMake(0, -70, screenWidth, screenHeight)];
		//[sectionBackgroundImage setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
		[sectionBackgroundContainer addSubview:sectionBackgroundImage];
		
		sectionBackgroundOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
		[sectionBackgroundOverlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
		[sectionBackgroundContainer addSubview:sectionBackgroundOverlay];
		
		self.pinMenu = [RSFlyoutMenu new];
		[self.pinMenu addActionWithTitle:@"PIN_TO_START" target:self action:@selector(pinSelectedApp)];
		[self.pinMenu addActionWithTitle:@"UNINSTALL" target:self action:@selector(uninstallSelectedApp)];
		
		dismissRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePinMenu)];
		[dismissRecognizer setEnabled:NO];
		[self.view addGestureRecognizer:dismissRecognizer];
		
		[self loadApps];
	}
	
	return self;
}

#pragma mark Delegate

- (void)setScrollEnabled:(BOOL)scrollEnabled {
	[self.view setScrollEnabled:scrollEnabled];
}

- (void)setContentOffset:(CGPoint)contentOffset {
	[self.view setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated {
	[self.view setContentOffset:contentOffset animated:animated];
}

- (CGPoint)contentOffset {
	return self.view.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self updateSectionsWithOffset:self.view.contentOffset.y];
}

- (void)updateSectionsWithOffset:(CGFloat)offset {
	for (int i=0; i<[sections count]; i++) {
		RSAppListSection* section = [sections objectAtIndex:i];
		
		if (section.yPosition - offset < 0 && (i+1) < sections.count) {
			if ([sections objectAtIndex:i+1] && (offset + 60) < [[sections objectAtIndex:i+1] yPosition]) {
				[section setFrame:CGRectMake(0, offset, self.view.frame.size.width, 60)];
				[sectionBackgroundContainer setFrame:CGRectMake(0, offset, self.view.frame.size.width, 60)];
				/*[sectionBackgroundImage setCenter:CGPointMake(screenWidth/2 + (-screenWidth + [[RSHomeScreenController sharedInstance] contentOffset].x),
															  screenHeight/2 - 70 - [[RSHomeScreenController sharedInstance] parallaxPosition])];*/
				[sectionBackgroundImage setCenter:CGPointMake(screenWidth/2 + (-screenWidth + [[[RSCore sharedInstance] homeScreenController] contentOffset].x),
															  screenHeight/2 - 70)];
			} else {
				[section setFrame:CGRectMake(0, [[sections objectAtIndex:i+1] yPosition] - 60, self.view.frame.size.width, 60)];
				[sectionBackgroundContainer setFrame:CGRectMake(0, [[sections objectAtIndex:i+1] yPosition] - 60, self.view.frame.size.width, 60)];
				/*[sectionBackgroundImage setCenter:CGPointMake(screenWidth/2  + (-screenWidth + [[RSHomeScreenController sharedInstance] contentOffset].x),
															  screenHeight/2 + (offset - [[sections objectAtIndex:i+1] yPosition] - 10)  - [[RSHomeScreenController sharedInstance] parallaxPosition])];*/
				[sectionBackgroundImage setCenter:CGPointMake(screenWidth/2 + (-screenWidth + [[[RSCore sharedInstance] homeScreenController] contentOffset].x),
															  screenHeight/2 + (offset - [[sections objectAtIndex:i+1] yPosition] - 10))];
			}
		} else {
			[section setFrame:CGRectMake(0, [section yPosition], self.view.frame.size.width, 60)];
		}
	}
	
	if (offset <= 0) {
		[sectionBackgroundContainer setHidden:YES];
	} else {
		[sectionBackgroundContainer setHidden:NO];
	}
}

- (void)setSectionOverlayAlpha:(CGFloat)alpha {
	[sectionBackgroundOverlay setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:alpha]];
}

#pragma mark App Management

- (void)loadApps {
	if (sections && appsBySection) {
		[sections makeObjectsPerformSelector:@selector(removeFromSuperview)];
		for (id key in appsBySection) {
			[[appsBySection objectForKey:key] makeObjectsPerformSelector:@selector(removeFromSuperview)];
		}
	}
	
	sections = [NSMutableArray new];
	apps = [NSMutableArray new];
	appsBySection = [NSMutableDictionary new];
	
	NSString* alphabet = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ@";
	NSString* numbers = @"1234567890";
	
	for (int i=0; i<28; i++) {
		[appsBySection setObject:[NSMutableArray new] forKey:[alphabet substringWithRange:NSMakeRange(i, 1)]];
	}
	
	NSArray* visibleIcons = [[[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] visibleIconIdentifiers] allObjects];
	for (int i=0; i<visibleIcons.count; i++) {
		SBLeafIcon* icon = [[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] leafIconForIdentifier:[visibleIcons objectAtIndex:i]];
		
		if (icon && [icon applicationBundleID] && ![[icon applicationBundleID] isEqualToString:@""] && ![icon isKindOfClass:NSClassFromString(@"SBDownloadingIcon")]) {
			RSApp* app = [[RSApp alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 56) bundleIdentifier:[icon applicationBundleID]];
			
			[self.view addSubview:app];
			[apps addObject:app];
			
			NSString* first;
			if (app.tileInfo.localizedDisplayName) {
				first = [[app.tileInfo.localizedDisplayName substringWithRange:NSMakeRange(0,1)] uppercaseString];
			} else if (app.tileInfo.displayName) {
				first = [[app.tileInfo.displayName substringWithRange:NSMakeRange(0,1)] uppercaseString];
			} else {
				first = [[[app.icon displayName] substringWithRange:NSMakeRange(0,1)] uppercaseString];
			}
			
			if (first != nil) {
				BOOL isString = [alphabet rangeOfString:first].location != NSNotFound;
				BOOL isNumeric = [numbers rangeOfString:first].location != NSNotFound;
				
				NSString* sectionLetter = @"";
				
				if (isString) {
					[[appsBySection objectForKey:first] addObject:app];
					sectionLetter = first;
				} else if (isNumeric) {
					[[appsBySection objectForKey:@"#"] addObject:app];
					sectionLetter = @"#";
				} else {
					[[appsBySection objectForKey:@"@"] addObject:app];
					sectionLetter = @"@";
				}
				
				if ([self sectionWithLetter:sectionLetter] == nil) {
					RSAppListSection* section = [[RSAppListSection alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60) letter:sectionLetter];
					[sections addObject:section];
				}
			}
		}
	}
	
	for (int i=0; i<28; i++) {
		NSArray* arrayToSort = [appsBySection objectForKey:[alphabet substringWithRange:NSMakeRange(i,1)]];
		
		if ([arrayToSort count] > 0) {
			arrayToSort = [arrayToSort sortedArrayUsingComparator:^NSComparisonResult(RSApp* app1, RSApp* app2) {
				return [[app1.icon displayName] caseInsensitiveCompare:[app2.icon displayName]];
			}];
			
			[appsBySection setObject:[arrayToSort mutableCopy] forKey:[alphabet substringWithRange:NSMakeRange(i,1)]];
		}
	}
	
	[self sortAppsAndLayout];
}

- (void)sortAppsAndLayout {
	NSString* alphabet = @"#ABCDEFGHIJKLMNOPQRSTUVWXYZ@";
	
	int yPos = 0;
	id previousSection = nil;
	for (int i=0; i<28; i++) {
		NSArray* currentSection = [appsBySection objectForKey:[alphabet substringWithRange:NSMakeRange(i,1)]];
		
		if ([currentSection count] > 0) {
			previousSection = [alphabet substringWithRange:NSMakeRange(i,1)];
			
			RSAppListSection* section = [self sectionWithLetter:previousSection];
			
			[section setFrame:CGRectMake(0, yPos, screenWidth, 60)];
			[section setOriginalCenter:section.center];
			[section setYPosition:yPos];
			
			yPos += 60;
			
			for (RSApp* app in currentSection) {
				[app setFrame:CGRectMake(0, yPos, screenWidth, 56)];
				[app setOriginalCenter:app.center];
				[app setHidden:NO];
				
				yPos += 56;
			}
		}
	}
	
	NSArray* sortedSections = [sections sortedArrayUsingComparator:^NSComparisonResult(RSAppListSection* app1, RSAppListSection* app2) {
		return [[NSNumber numberWithFloat:app1.yPosition] compare:[NSNumber numberWithFloat:app2.yPosition]];
	}];
	sections = [sortedSections mutableCopy];
	
	[self.view addSubview:sectionBackgroundContainer];
	for (int i=0; i<sections.count; i++) {
		[self.view addSubview:[sections objectAtIndex:i]];
	}
	
	CGRect contentRect = CGRectZero;
	for (UIView *view in self.view.subviews) {
		contentRect = CGRectUnion(contentRect, view.frame);
	}
	[self.view setContentSize:contentRect.size];
}

- (RSAppListSection*)sectionWithLetter:(NSString*)letter {
	if (letter != nil) {
		for (RSAppListSection* section in sections) {
			if ([[section displayName] isEqualToString:letter]) {
				return section;
				break;
			}
		}
	}
	
	return nil;
}

- (RSApp*)appForBundleIdentifier:(NSString*)bundleIdentifier {
	for (RSApp* app in apps) {
		if ([[app.icon applicationBundleID] isEqualToString:bundleIdentifier]) {
			return app;
			break;
		}
	}
	
	return nil;
}

#pragma mark Pin Menu

- (void)showPinMenuForApp:(RSApp*)app withPoint:(CGPoint)point {
	[self.view sendSubviewToBack:app];
	self.selectedApp = app;
	
	if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] tileForBundleIdentifier:[[self.selectedApp icon] applicationBundleID]]) {
		[self.pinMenu setActionDisabled:YES atIndex:0];
	} else {
		[self.pinMenu setActionDisabled:NO atIndex:0];
	}
	
	[self.pinMenu setActionHidden:![[self.selectedApp icon] isUninstallSupported] atIndex:1];
	
	[[[RSCore sharedInstance] homeScreenController] setScrollEnabled:NO];
	[self.view setScrollEnabled:NO];
	[dismissRecognizer setEnabled:YES];
	
	for (UIView* view in self.view.subviews) {
		[view setUserInteractionEnabled:NO];
	}
	
	CGRect globalFrame = [self.view convertRect:app.frame toView:[[[RSCore sharedInstance] homeScreenController] view]];
	
	[self.pinMenu appearAtPosition:CGPointMake(point.x, globalFrame.origin.y)];
}

- (void)hidePinMenu {
	[self.pinMenu disappear];
	
	for (UIView* view in self.view.subviews) {
		[view setUserInteractionEnabled:YES];
	}
	
	[dismissRecognizer setEnabled:NO];
	[[[RSCore sharedInstance] homeScreenController] setScrollEnabled:YES];
	[(UIScrollView*)self.view setScrollEnabled:YES];
}

- (void)pinSelectedApp {
	[self hidePinMenu];
	
	if ([[[[RSCore sharedInstance] homeScreenController] startScreenController] tileForBundleIdentifier:[[self.selectedApp icon] applicationBundleID]]) {
		return;
	}
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[[[[RSCore sharedInstance] homeScreenController] startScreenController] pinTileWithBundleIdentifier:[[self.selectedApp icon] applicationBundleID]];
		self.selectedApp = nil;
	});
}

- (void)uninstallSelectedApp {
	self.isUninstallingApp = YES;
	[self hidePinMenu];
	
	if ([self.selectedApp.icon isUninstallSupported]) {
		[self.selectedApp.icon setUninstalled];
		[self.selectedApp.icon completeUninstall];
		
		[[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] model] removeIconForIdentifier:[self.selectedApp.icon applicationBundleID]];
		
		[UIView animateWithDuration:0.2 animations:^{
			[self.selectedApp setEasingFunction:easeOutQuint forKeyPath:@"frame"];
			
			[self.selectedApp setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
			[self.selectedApp.layer setOpacity:0.0];
		} completion:^(BOOL finished) {
			self.selectedApp = nil;
			self.isUninstallingApp = NO;
			
			[self loadApps];
			[self updateSectionsWithOffset:self.view.contentOffset.y];
		}];
	}
}

@end
