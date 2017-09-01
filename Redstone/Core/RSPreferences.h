#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>

@interface RSPreferences : NSObject {
	HBPreferences* preferences;
}

+ (id)preferences;
- (id)objectForKey:(NSString*)key;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

@end
