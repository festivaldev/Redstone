#import "RSTile.h"

@protocol RSLiveTileInterface <NSObject>

@required
@property (nonatomic, assign) BOOL isReadyForDisplay;
@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, assign) RSTile* tile;

- (id)initWithFrame:(CGRect)frame tile:(RSTile*)tile;
- (NSArray*)viewsForSize:(int)size;
- (CGFloat)updateInterval;

@optional
- (void)update;
- (void)hasStarted;
- (void)hasStopped;
- (void)triggerAnimation;
- (void)prepareForRemoval;

@end
