#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@class RSStartScreenScrollView, RSTile;

@interface RSStartScreenController : NSObject {
	NSMutableArray* pinnedTiles;
	NSMutableArray* pinnedIdentifiers;
}

@property (nonatomic, strong) RSStartScreenScrollView* view;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) RSTile* selectedTile;

- (void)setScrollEnabled:(BOOL)scrollEnabled;
- (void)setContentOffset:(CGPoint)contentOffset;
- (void)setTilesHidden:(BOOL)hidden;

- (void)loadTiles;
- (void)saveTiles;
- (void)pinTileWithBundleIdentifier:(NSString*)bundleIdentifier;
- (void)unpinTile:(RSTile*)tile;
- (RSTile*)tileForBundleIdentifier:(NSString*)bundleIdentifier;

- (void)setIsEditing:(BOOL)isEditing;
- (void)setSelectedTile:(RSTile*)selectedTile;
- (void)snapTile:(RSTile*)tile withTouchPosition:(CGPoint)touchPosition;
- (void)moveAffectedTilesForTile:(RSTile *)movedTile hasResizedTile:(BOOL)hasResizedTile;
- (void)eliminateEmptyRows;
- (void)applyPendingFrameUpdates;
- (NSMutableArray*)sortPinnedTiles;

@end
