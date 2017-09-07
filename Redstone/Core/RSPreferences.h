#import <Foundation/Foundation.h>

#if (!TARGET_OS_SIMULATOR)
#import <Cephei/HBPreferences.h>
#endif

@interface RSPreferences : NSObject {
#if (!TARGET_OS_SIMULATOR)
	HBPreferences* preferences;
#else
	NSMutableDictionary* preferences;
#endif
}

+ (id)preferences;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

@end
