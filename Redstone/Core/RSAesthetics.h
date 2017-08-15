#import <UIKit/UIKit.h>

@class RSTileInfo;

@interface RSAesthetics : NSObject

+ (NSString*)localizedStringForKey:(NSString*)key;
+ (UIImage*)lockScreenWallpaper;
+ (UIImage*)homeScreenWallpaper;
+ (UIColor*)accentColor;
+ (UIColor*)accentColorForTile:(RSTileInfo*)tileInfo;
+ (CGFloat)tileOpacity;
+ (UIImage*)imageForTileWithBundleIdentifier:(NSString*)bundleIdentifier;
+ (UIImage*)imageForTileWithBundleIdentifier:(NSString*)bundleIdentifier size:(int)size colored:(BOOL)colored;

@end
