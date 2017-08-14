#import <UIKit/UIKit.h>

@class RSAppListScrollView, RSAppListSection, RSApp, RSFlyoutMenu;

@interface RSAppListController : NSObject <UIScrollViewDelegate> {
	NSMutableArray* sections;
	NSMutableArray* apps;
	NSMutableDictionary* appsBySection;
	
	UIView* sectionBackgroundContainer;
	UIImageView* sectionBackgroundImage;
	UIView* sectionBackgroundOverlay;
	
	UITapGestureRecognizer* dismissRecognizer;
}

@property (nonatomic, strong) RSAppListScrollView* view;
@property (nonatomic, strong) RSApp* selectedApp;
@property (nonatomic, strong) RSFlyoutMenu* pinMenu;

- (void)setScrollEnabled:(BOOL)scrollEnabled;
- (void)setContentOffset:(CGPoint)contentOffset;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (CGPoint)contentOffset;
- (void)updateSectionsWithOffset:(CGFloat)offset;
- (void)setSectionOverlayAlpha:(CGFloat)alpha;

- (void)loadApps;
- (void)sortAppsAndLayout;
- (RSAppListSection*)sectionWithLetter:(NSString*)letter;
- (RSApp*)appForBundleIdentifier:(NSString*)bundleIdentifier;

- (void)showPinMenuForApp:(RSApp*)app withPoint:(CGPoint)point;
- (void)hidePinMenu;

@end
