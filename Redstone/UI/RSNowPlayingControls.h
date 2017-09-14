#import <UIKit/UIKit.h>

@class _UILegibilitySettings;

@interface RSNowPlayingControls : UIView {
	UILabel* mediaTitleLabel;
	UILabel* mediaSubtitleLabel;
	
	RSTiltView* prevTitleButton;
	RSTiltView* playPauseButton;
	RSTiltView* nextTitleButton;
}

- (void)updateNowPlayingInfo;
- (void)updateWithLegibilitySettings:(_UILegibilitySettings*)settings;

@end
