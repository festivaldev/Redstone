#import "RSTiltView.h"

@interface RSAlertAction : RSTiltView

@property (copy) void (^handler) (void);

+ (id)actionWithTitle:(NSString*)title handler:(void (^)(void))handler;

@end
