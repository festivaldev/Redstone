#import <Foundation/Foundation.h>
#import <MediaPlayer/MPVolumeController.h>

@interface RSAudioController : NSObject {
	MPVolumeController* audioVideoController;
	MPVolumeController* ringerController;
}

@end
