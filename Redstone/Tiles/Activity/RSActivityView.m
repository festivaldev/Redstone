//
//  RSActivityView.m
//  Activity
//
//  Created by Janik Schmidt on 16.09.17.
//

#import "RSActivityView.h"

@implementation RSActivityView

- (void)awakeFromNib {
	[super awakeFromNib];
	
	NSArray* fontFeatures = @[
							  @{
								  UIFontFeatureTypeIdentifierKey: @(38),
								  UIFontFeatureSelectorIdentifierKey: @(1)
								  }
							  ];
	UIFont* font = [UIFont fontWithDescriptor:[[[UIFont fontWithName:@".SFCompactRounded-Regular" size:22] fontDescriptor] fontDescriptorByAddingAttributes:@{UIFontDescriptorFeatureSettingsAttribute:fontFeatures}] size:0.0];
	
	ringView = [[HKActivityRingView alloc] initWithFrame:CGRectMake(0, 0, 78, 78)];
	[activityRingContainer addSubview:ringView];
	
	activityWidgetBundle = [NSBundle bundleWithPath:@"/Applications/Fitness.app/PlugIns/activity-widget.appex"];
	NSString* moveUnitText = [[[HKUnit calorieUnit] unitString] uppercaseString];
	NSString* exerciseUnitText = [[activityWidgetBundle localizedStringForKey:@"ACTIVITY_SUMMARY_EXERCISE_UNIT" value:nil table:@"Localizable"] uppercaseString];
	NSString* standUnitText = [[activityWidgetBundle localizedStringForKey:@"ACTIVITY_SUMMARY_STAND_UNIT" value:nil table:@"Localizable"] uppercaseString];
	
	[moveTitle setText:[activityWidgetBundle localizedStringForKey:@"ACTIVITY_RING_TITLE_MOVE" value:nil table:nil]];
	[exerciseTitle setText:[activityWidgetBundle localizedStringForKey:@"ACTIVITY_RING_TITLE_EXERCISE" value:nil table:nil]];
	[standTitle setText:[activityWidgetBundle localizedStringForKey:@"ACTIVITY_RING_TITLE_STAND" value:nil table:nil]];
	
	[moveLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Regular" size:22]];
	[exerciseLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Regular" size:22]];
	[standLabel setFont:[UIFont fontWithName:@".SFCompactRounded-Regular" size:22]];
	
	HKHealthStore* healthStore = [HKHealthStore new];
	[healthStore requestAuthorizationToShareTypes:nil readTypes:[NSSet setWithObjects:[HKObjectType activitySummaryType], nil] completion:^(BOOL success, NSError* error) {}];
	
	NSCalendar* calendar = [NSCalendar autoupdatingCurrentCalendar];
	NSDateComponents* dateComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:[NSDate date]];
	[dateComponents setCalendar:calendar];
	NSPredicate* predicate = [HKQuery predicateForActivitySummaryWithDateComponents:dateComponents];
	
	HKQuery* query = [[HKActivitySummaryQuery alloc] initWithPredicate:predicate resultsHandler:^(HKActivitySummaryQuery* query, NSArray* activitySummaries, NSError* error) {
		if (activitySummaries.count > 0) {
			HKActivitySummary* summary = [activitySummaries objectAtIndex:0];
			
			[summary setActiveEnergyBurned:[HKQuantity quantityWithUnit:[HKUnit kilocalorieUnit] doubleValue:arc4random_uniform(550)]];
			[summary setAppleExerciseTime:[HKQuantity quantityWithUnit:[HKUnit minuteUnit] doubleValue:arc4random_uniform(30)]];
			[summary setAppleStandHours:[HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:arc4random_uniform(12)]];
			[ringView setActivitySummary:summary animated:YES];
			
			double activeEnergyBurned = [[summary activeEnergyBurned] doubleValueForUnit:[HKUnit kilocalorieUnit]];
			double activeEnergyBurnedGoal = [[summary activeEnergyBurnedGoal] doubleValueForUnit:[HKUnit kilocalorieUnit]];
			
			NSMutableAttributedString* activeEnergyBurnedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i/%i%@", (int)activeEnergyBurned, (int)activeEnergyBurnedGoal, moveUnitText]];
			[activeEnergyBurnedText addAttribute:NSFontAttributeName value:font range:[[activeEnergyBurnedText string] rangeOfString:moveUnitText]];
			[moveLabel setAttributedText:activeEnergyBurnedText];
			
			double appleExerciseTime = [[summary appleExerciseTime] doubleValueForUnit:[HKUnit minuteUnit]];
			double appleExcerciseTimeGoal = [[summary appleExerciseTimeGoal] doubleValueForUnit:[HKUnit minuteUnit]];
			
			NSMutableAttributedString* appleExerciseTimeText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i/%i%@", (int)appleExerciseTime, (int)appleExcerciseTimeGoal, exerciseUnitText]];
			[appleExerciseTimeText addAttribute:NSFontAttributeName value:font range:[[appleExerciseTimeText string] rangeOfString:exerciseUnitText]];
			[exerciseLabel setAttributedText:appleExerciseTimeText];
			
			double appleStandHours = [[summary appleStandHours] doubleValueForUnit:[HKUnit countUnit]];
			double appleStandHoursGoal = [[summary appleStandHoursGoal] doubleValueForUnit:[HKUnit countUnit]];
			
			NSMutableAttributedString* appleStandHoursText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i/%i%@", (int)appleStandHours, (int)appleStandHoursGoal, standUnitText]];
			[appleStandHoursText addAttribute:NSFontAttributeName value:font range:[[appleStandHoursText string] rangeOfString:standUnitText]];
			[standLabel setAttributedText:appleStandHoursText];
		}
	}];
	
	[healthStore executeQuery:query];
}

@end
