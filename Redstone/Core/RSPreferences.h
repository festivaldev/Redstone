#import <Foundation/Foundation.h>

@interface RSPreferences : NSObject {
	NSMutableDictionary* preferences;
}

+ (id)preferences;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

@end
