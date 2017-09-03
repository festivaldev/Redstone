#import <UIKit/UIKit.h>

@class RSSlider;

@interface RSVolumeView : UIView {
	NSString* category;
	
	UILabel* categoryLabel;
	UILabel* volumeValueLabel;
}

@property (nonatomic, strong) RSSlider* slider;

- (id)initWithFrame:(CGRect)frame forCategory:(NSString*)_category;
- (void)setVolumeValue:(float)volumeValue;

@end
