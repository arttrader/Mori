//
//  MoriAppDelegate.h
//  Mori
//
//  Created by jhirota on 2012/09/19.
//  Copyright (c) 2012年 J Hirota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "iRate.h"

#define g_IS_IPHONE_5_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 568.0f && [[UIScreen mainScreen] bounds].size.height < 1024.0f
#define g_IS_IPHONE_4_SCREEN    [[UIScreen mainScreen] bounds].size.height >= 480.0f && [[UIScreen mainScreen] bounds].size.height < 568.0f
#define SITE_URL @"http://yohaku.narasaku.jp"

#define APPLE_APP_ID 658285664
#define APP_TITLE @"森のメッセージ"

// Google Analytics account ID
#define GA_ID @"UA-41325324-1"
// Dispatch period in seconds.
static const NSInteger kDispatchPeriodSeconds = 20;

//@class MoriMasterViewController;

@interface MoriAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;
@property (nonatomic) BOOL optionPurchased;
@property (nonatomic) BOOL isVideoFullscreen;
@property (nonatomic, retain) id<GAITracker> tracker;

@end
