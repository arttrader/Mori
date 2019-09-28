//
//  MainMenuViewController.m
//  Mori
//
//  Created by Jon Hirota on 2013/03/17.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import "MoriAppDelegate.h"
#import "MainMenuViewController.h"
#import "MoriMasterViewController.h"
#import "MoriIntroViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize adView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;

    UINavigationItem *n = [self navigationItem];
    [n setTitle:APP_TITLE];
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor colorWithRed:0.33 green:0.66 blue:0.32 alpha:1.0]];

//    UIFont *bFont = [UIFont fontWithName:@"uzuraFont" size:15.0];
//    self.explLabel.font = bFont;
    
    MoriAppDelegate *appDelegate = (MoriAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.optionPurchased)
    {
        NSLog(@"Option purchased\n");
        CGFloat yOffset = 20;
        if (g_IS_IPHONE_5_SCREEN) yOffset = -40;
        
        CGRect rect = self.RouletteBtn.frame;
        rect.origin.y = rect.origin.y + yOffset;
        self.RouletteBtn.frame = rect;
        rect = self.SelectionBtn.frame;
        rect.origin.y = rect.origin.y + yOffset;
        self.SelectionBtn.frame = rect;
        rect = self.IconBtn.frame;
        rect.origin.y = rect.origin.y + yOffset;
        self.IconBtn.frame = rect;
        rect = self.textLabel1.frame;
        rect.origin.y = rect.origin.y + yOffset;
        self.textLabel1.frame = rect;
        rect = self.textLabel2.frame;
        rect.origin.y = rect.origin.y + yOffset;
        self.textLabel2.frame = rect;
        rect = self.textLabel3.frame;
        rect.origin.y = rect.origin.y + yOffset;
        self.textLabel3.frame = rect;
    }
    else
    {
        NSLog(@"Option not purchased\n");
        //adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
        //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        adView.delegate = (id)self;
    }
    // if first time, display Info page
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger nVisits = [defaults integerForKey:@"numberOfVisits"];
    if (!nVisits) {
            MoriIntroViewController *introView = [appDelegate.mainStoryboard instantiateViewControllerWithIdentifier:@"IntroView"];
            [self presentModalViewController:introView animated:YES];
    }
    nVisits++;
    [defaults setInteger:nVisits forKey:@"numberOfVisits"];
    [defaults synchronize];
    
    [[iRate sharedInstance] logEvent:YES];
    if ([[iRate sharedInstance] shouldPromptForRating])
        [[iRate sharedInstance] promptForRating];
}

- (IBAction)onClickRoulette:(id)sender
{
    MoriAppDelegate *appDelegate = (MoriAppDelegate *)[[UIApplication sharedApplication] delegate];
    MoriMasterViewController *masterViewController = [appDelegate.mainStoryboard instantiateViewControllerWithIdentifier: @"MasterViewController"];
    // ...
    masterViewController.displayType = 1;
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:masterViewController animated:YES];
}

- (IBAction)onClickSelection:(id)sender
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        MoriAppDelegate *appDelegate = (MoriAppDelegate *)[[UIApplication sharedApplication] delegate];
        MoriMasterViewController *masterViewController = [appDelegate.mainStoryboard instantiateViewControllerWithIdentifier: @"MasterViewController"];
        // ...
        masterViewController.displayType = 2;
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:masterViewController animated:YES];
    }
    else {
        // show alert view to ask if user wants to review
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"システムをアップデートして下さい"
                              message:@"ごめんなさい >_< この機能はiOS 6.0以上のみに対応しております。" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRouletteBtn:nil];
    [self setSelectionBtn:nil];
    [self setIconBtn:nil];
    [self setAdView:nil];
    [self setExplLabel:nil];
    [self setTextLabel1:nil];
    [self setTextLabel2:nil];
    [self setTextLabel3:nil];
    [super viewDidUnload];
}
@end
