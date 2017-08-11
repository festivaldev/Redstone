#import <UIKit/UIKit.h>

@interface RSMetrics : NSObject

+ (int)columns;
+ (CGFloat)tileBorderSpacing;
+ (CGSize)tileDimensionsForSize:(int)size;
+ (CGSize)tileIconDimensionsForSize:(int)size;
+ (CGFloat)sizeForPosition;

@end
