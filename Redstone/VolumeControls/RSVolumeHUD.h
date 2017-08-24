#import <UIKit/UIKit.h>

typedef void (^MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef information);
void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingInfoCompletion completion);

@class RSVolumeView, RSSlider, RSTiltView, RSNowPlayingControls;

@interface RSVolumeHUD : UIView {
	NSTimer* animationTimer;
	
	RSVolumeView* ringerVolumeView;
	RSSlider* ringerSlider;
	RSTiltView* ringerMuteButton;
	
	RSVolumeView* mediaVolumeView;
	RSSlider* mediaSlider;
	RSTiltView* mediaMuteButton;
	
	RSVolumeView* headphoneVolumeView;
	RSSlider* headphoneSlider;
	RSTiltView* headphoneMuteButton;
	
	RSTiltView* extendButton;
	UIButton* vibrationButton;
	
	RSNowPlayingControls* nowPlayingControls;
}

@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) BOOL isExtended;
@property (nonatomic, assign) BOOL isShowingNowPlayingControls;
@property (nonatomic, assign) BOOL isShowingHeadphoneVolume;

- (void)updateVolumeValues;
- (void)appear;
- (void)disappear;
- (void)resetAnimationTimer;

@end
