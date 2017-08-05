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

- (void)loadTiles;
- (void)saveTiles;

- (void)setIsEditing:(BOOL)isEditing;
- (void)setSelectedTile:(RSTile*)selectedTile;

@end
