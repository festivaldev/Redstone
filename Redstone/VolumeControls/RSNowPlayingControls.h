#import <UIKit/UIKit.h>

@interface RSNowPlayingControls : UIView {
	UILabel* mediaTitleLabel;
	UILabel* mediaSubtitleLabel;
	
	RSTiltView* prevTitleButton;
	RSTiltView* playPauseButton;
	RSTiltView* nextTitleButton;
}

@end
