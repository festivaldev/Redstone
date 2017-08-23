#import <Foundation/Foundation.h>
#import "MPVolumeControllerDelegate.h"

@interface MPVolumeController : NSObject

@property (nonatomic,readonly) float volumeValue;
@property (assign,nonatomic) BOOL muted;
@property (nonatomic,copy) NSString * volumeAudioCategory;

-(float)volumeValue;
-(float)setVolumeValue:(float)arg1 ;
-(NSString *)volumeAudioCategory;
-(void)setVolumeAudioCategory:(NSString *)arg1;
-(BOOL)muted;
-(void)setMuted:(BOOL)arg1;
-(void)setDelegate:(id<MPVolumeControllerDelegate>)arg1 ;

@end
