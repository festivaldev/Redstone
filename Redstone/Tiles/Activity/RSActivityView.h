//
//  RSActivityView.h
//  Activity
//
//  Created by Janik Schmidt on 16.09.17.
//

#import <UIKit/UIKit.h>
#import <HealthKit/HealthKit.h>
#import <HealthKitUI/HealthKitUI.h>

@interface RSActivityView : UIView {
	NSBundle* activityWidgetBundle;
	
	HKActivityRingView* ringView;
	IBOutlet UIView* activityRingContainer;
	
	IBOutlet UILabel* moveTitle;
    IBOutlet UILabel* moveLabel;
	IBOutlet UILabel* exerciseTitle;
    IBOutlet UILabel* exerciseLabel;
    IBOutlet UILabel* standTitle;
	IBOutlet UILabel* standLabel;
}

@end
