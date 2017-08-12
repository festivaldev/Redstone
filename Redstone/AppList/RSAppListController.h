#import <UIKit/UIKit.h>

@class RSAppListScrollView, RSAppListSection, RSApp;

@interface RSAppListController : NSObject <UIScrollViewDelegate> {
	NSMutableArray* sections;
	NSMutableArray* apps;
	NSMutableDictionary* appsBySection;
	
	UIView* sectionBackgroundContainer;
	UIImageView* sectionBackgroundImage;
	UIView* sectionBackgroundOverlay;
}

@property (nonatomic, strong) RSAppListScrollView* view;

- (void)setScrollEnabled:(BOOL)scrollEnabled;
- (void)setContentOffset:(CGPoint)contentOffset;
- (void)updateSectionsWithOffset:(CGFloat)offset;
- (void)setSectionOverlayAlpha:(CGFloat)alpha;

- (void)loadApps;
- (void)sortAppsAndLayout;
- (RSAppListSection*)sectionWithLetter:(NSString*)letter;
- (RSApp*)appForBundleIdentifier:(NSString*)bundleIdentifier;

@end
