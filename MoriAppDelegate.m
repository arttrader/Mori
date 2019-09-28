//
//  MoriAppDelegate.m
//  Mori
//
//  Created by jhirota on 2012/09/19.
//  Copyright (c) 2012年 J Hirota. All rights reserved.
//

#import "MoriAppDelegate.h"
#import "MoriMasterViewController.h"


@implementation MoriAppDelegate

@synthesize window;
@synthesize mainStoryboard;

- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)pWindow {
    return [pWindow.rootViewController.navigationController.topViewController isKindOfClass:[MoriMasterViewController class]] ?
        UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [iRate sharedInstance].promptAtLaunch = NO;
    [[iRate sharedInstance] setAppStoreID:APPLE_APP_ID];
    [iRate sharedInstance].daysUntilPrompt = 3;
    [iRate sharedInstance].usesUntilPrompt = 5;
    [iRate sharedInstance].eventsUntilPrompt = 5;
    // for Google Analytics
    //    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = kDispatchPeriodSeconds;
    //    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:GA_ID];
    // Override point for customization after application launch.
    if (g_IS_IPHONE_5_SCREEN)
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    else
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    [window makeKeyAndVisible];
    self.optionPurchased = NO;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
