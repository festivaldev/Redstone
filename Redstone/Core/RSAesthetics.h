#import <UIKit/UIKit.h>

@class RSTileInfo;

@interface RSAesthetics : NSObject

+ (UIColor*)accentColor;
+ (UIColor*)accentColorForTile:(RSTileInfo*)tileInfo;
+ (CGFloat)tileOpacity;

@end
