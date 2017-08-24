#import <UIKit/UIKit.h>

@interface RSSlider : UIControl {
	float minValue;
	float maxValue;
	float currentValue;
	
	CALayer* trackLayer;
	CALayer* trackFillLayer;
	CALayer* thumbLayer;
}

- (float)currentValue;
- (float)minValue;
- (float)maxValue;
- (void)setValue:(float)value;
- (void)setMinValue:(float)value;
- (void)setMaxValue:(float)value;

@end
