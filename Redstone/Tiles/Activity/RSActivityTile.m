//
//  RSActivityTile.m
//  Activity
//
//  Created by Janik Schmidt on 16.09.17.
//

#import "RSActivityTile.h"

@implementation RSActivityTile

- (id)initWithFrame:(CGRect)frame tile:(RSTile *)tile {
    if (self = [super initWithFrame:frame]) {
        self.tile = tile;
        
        activityView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"ActivityView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:activityView];
    }
    
    return self;
}

- (NSArray*)viewsForSize:(int)size {
    return nil;
}

- (BOOL)isReadyForDisplay {
    return YES;
}

- (CGFloat)updateInterval {
    return 0;
}

@end
