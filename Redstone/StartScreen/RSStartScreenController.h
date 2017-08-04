#import <UIKit/UIKit.h>

@interface RSStartScreenController : NSObject {
	NSMutableArray* pinnedTiles;
	NSMutableArray* pinnedIdentifiers;
}

@property (nonatomic, strong) UIScrollView* view;

- (void)loadTiles;
- (void)saveTiles;

@end
