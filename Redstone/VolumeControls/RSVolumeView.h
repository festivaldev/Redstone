#import <UIKit/UIKit.h>

@interface RSVolumeView : UIView {
	NSString* category;
	
	UILabel* categoryLabel;
	UILabel* volumeValueLabel;
}

- (id)initWithFrame:(CGRect)frame forCategory:(NSString*)_category;

@end
