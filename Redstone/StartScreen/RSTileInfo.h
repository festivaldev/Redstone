#import <Foundation/Foundation.h>

@interface RSTileInfo : NSObject {
	NSDictionary* tileInfo;
	NSBundle* tileBundle;
}

@property (nonatomic, assign, readonly) BOOL fullSizeArtwork;
@property (nonatomic, assign, readonly) BOOL tileHidesLabel;
@property (nonatomic, assign, readonly) BOOL usesCornerBadge;
@property (nonatomic, assign, readonly) BOOL hasColoredIcon;
@property (nonatomic, assign, readonly) BOOL displaysNotificationsOnTile;

@property (nonatomic, strong, readonly) NSString* displayName;
@property (nonatomic, strong, readonly) NSString* localizedDisplayName;
@property (nonatomic, strong, readonly) NSString* accentColor;
@property (nonatomic, strong, readonly) NSString* tileAccentColor;
@property (nonatomic, strong, readonly) NSString* launchScreenAccentColor;
@property (nonatomic, strong, readonly) NSArray* supportedSizes;
@property (nonatomic, strong, readonly) NSDictionary* labelHiddenForSizes;
@property (nonatomic, strong, readonly) NSDictionary* cornerBadgeForSizes;

- (id)initWithBundleIdentifier:(NSString*)bundleIdentifier;

@end
