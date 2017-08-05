#define PREFERENCES_PATH @"/var/mobile/Library/Preferences/ml.festival.redstone.plist"
#define RESOURCES_PATH @"/var/mobile/Library/FESTIVAL/Redstone"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

#import <objc/runtime.h>

#import "headers/SpringBoard.h"

#pragma mark Libraries
#import "Libraries/CAKeyframeAnimation+AHEasing.h"
#import "Libraries/easing.h"
#import "Libraries/UIFont+WDCustomLoader.h"
#import "Libraries/UIImageAverageColorAddition.h"
#import "Libraries/UIView+Easing.h"

#pragma mark Core
#import "Core/RSCore.h"
#import "Core/RSPreferences.h"
#import "Core/RSMetrics.h"

#pragma mark Home Screen
#import "HomeScreen/RSHomeScreenController.h"
#import "HomeScreen/RSHomeScreenScrollView.h"

#pragma mark Start Screen
#import "StartScreen/RSStartScreenController.h"
#import "StartScreen/RSStartScreenScrollView.h"
#import "StartScreen/RSTile.h"

#pragma mark App List
#import "AppList/RSAppListController.h"
