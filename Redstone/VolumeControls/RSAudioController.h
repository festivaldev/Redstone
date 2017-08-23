#import <UIKit/UIKit.h>
#import <MediaPlayer/MPVolumeController.h>
#import <MediaPlayer/MPVolumeControllerDelegate.h>

@class RSVolumeHUD;

@interface RSAudioController : NSObject <MPVolumeControllerDelegate> {
	MPVolumeController* audioVideoController;
	MPVolumeController* ringerController;
	
	RSVolumeHUD* volumeHUD;
}

@property (nonatomic, strong) UIWindow* window;

- (void)volumeIncreasedForCategory:(NSString*)category;
- (void)volumeDecreasedForCategory:(NSString*)category;

@end
