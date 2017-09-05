#import <UIKit/UIKit.h>
#import "StartScreen/RSLiveTileInterface.h"

@interface RSWeatherTile : UIView <RSLiveTileInterface>

@property (nonatomic, assign) BOOL isReadyForDisplay;
@property (nonatomic, assign) BOOL isStarted;
@property (nonatomic, assign) RSTile* tile;

@end
