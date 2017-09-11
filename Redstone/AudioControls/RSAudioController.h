#import <UIKit/UIKit.h>
#import <MediaPlayer/MPVolumeController.h>
#import <MediaPlayer/MPVolumeControllerDelegate.h>

@class AVSystemController, RSVolumeHUD;

@interface RSAudioController : UIViewController <MPVolumeControllerDelegate> {
	AVSystemController* audioVideoController;
	
	float mediaVolume;
	float ringerVolume;
	
	RSVolumeHUD* volumeHUD;
	
	__block BOOL isPlaying;
	__block UIImage* artwork;
	__block NSString* artist;
	__block NSString* title;
	__block NSString* album;
}

@property (nonatomic, strong) UIWindow* window;

- (float)mediaVolume;
- (void)setMediaVolume:(float)_mediaVolume;
- (float)ringerVolume;
- (void)setRingerVolume:(float)_ringerVolume;

- (BOOL)canDisplayHUD;
- (void)displayHUDIfPossible;
- (void)hideVolumeHUD;
- (BOOL)isShowingVolumeHUD;

- (void)volumeIncreasedForCategory:(NSString*)category volumeValue:(float)volumeValue;
- (void)volumeDecreasedForCategory:(NSString*)category volumeValue:(float)volumeValue;

- (void)nowPlayingInfoDidChange;
- (BOOL)isPlaying;
- (UIImage*)artwork;
- (NSString*)artist;
- (NSString*)title;
- (NSString*)album;

@end
