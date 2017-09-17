//
//  RSActivityTile.h
//  Activity
//
//  Created by Janik Schmidt on 16.09.17.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>
#import <HealthKitUI/HealthKitUI.h>

#import "StartScreen/RSLiveTileInterface.h"
#import "RSActivityView.h"

@interface RSActivityTile : UIView <RSLiveTileInterface> {
    RSActivityView* activityView;
}

@property (nonatomic, assign) BOOL started;
@property (nonatomic, strong) RSTile* tile;

@end
