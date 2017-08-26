#import <Foundation/Foundation.h>

@interface RSPreferences : NSObject {
	NSMutableDictionary* preferences;
}

@property (nonatomic, assign, readonly) BOOL enabled;
@property (nonatomic, assign, readonly) BOOL homeScreenEnabled;
@property (nonatomic, assign, readonly) BOOL volumeControlsEnabled;
@property (nonatomic, assign, readonly) BOOL lockScreenEnabled;
@property (nonatomic, assign, readonly) NSString* accentColor;
@property (nonatomic, assign, readonly) float tileOpacity;
@property (nonatomic, assign, readonly) int columns;
@property (nonatomic, assign, readonly) NSArray* twoColumnLayout;
@property (nonatomic, assign, readonly) NSArray* threeColumnLayout;

+ (id)preferences;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

@end
