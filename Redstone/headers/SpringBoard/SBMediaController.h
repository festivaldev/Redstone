#import <Foundation/Foundation.h>

@interface SBMediaController : NSObject

+ (id)sharedInstance;
- (BOOL)isRingerMuted;
- (void)setRingerMuted:(BOOL)arg1;
- (BOOL)changeTrack:(int)arg1;
- (BOOL)togglePlayPause;

@end
