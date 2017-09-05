#import "RSTile.h"

@protocol RSLiveTileInterface <NSObject>

@required
@property (nonatomic, assign) BOOL started;
@property (nonatomic, strong) RSTile* tile;

- (id)initWithFrame:(CGRect)frame tile:(RSTile*)tile;
- (NSArray*)viewsForSize:(int)size;
- (CGFloat)updateInterval;
- (BOOL)isReadyForDisplay;

@optional
- (void)update;
- (void)hasStarted;
- (void)hasStopped;
- (void)triggerAnimation;
- (void)prepareForRemoval;

@end
