#import <UIKit/UIKit.h>

@class RSTileInfo;

@interface RSAesthetics : NSObject

+ (NSString*)localizedStringForKey:(NSString*)key;
+ (UIImage*)lockScreenWallpaper;
+ (UIImage*)homeScreenWallpaper;
+ (UIColor*)accentColor;
+ (UIColor*)accentColorForTile:(RSTileInfo*)tileInfo;
+ (UIColor*)colorForCurrentThemeByCategory:(NSString*)colorCategory;
+ (CGFloat)tileOpacity;
+ (UIImage*)imageForTileWithBundleIdentifier:(NSString*)bundleIdentifier;
+ (UIImage*)imageForTileWithBundleIdentifier:(NSString*)bundleIdentifier size:(int)size colored:(BOOL)colored;
+ (UIColor *)readableForegroundColorForBackgroundColor:(UIColor*)backgroundColor;

@end
