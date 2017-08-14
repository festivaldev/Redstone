#import <Foundation/Foundation.h>

@class SBLeafIcon;

@interface SBIconModel : NSObject

- (SBLeafIcon*)leafIconForIdentifier:(id)arg1;
- (id)visibleIconIdentifiers;
- (void)removeIconForIdentifier:(id)arg1 ;

@end
