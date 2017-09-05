#import "RSWeatherTile.h"

@implementation RSWeatherTile

- (id)initWithFrame:(CGRect)frame tile:(RSTile*)tile {
	if (self = [super initWithFrame:frame]) {
		self.tile = tile;
	}
	
	return self;
}

- (NSArray*)viewsForSize:(int)size {
	return nil;
}

- (CGFloat)updateInterval {
	return -1;
}

@end
