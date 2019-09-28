//
//  CoverViewController.m
//  Mori
//
//  Created by Jon Hirota on 2013/04/13.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import "CoverViewController.h"
#import "MoriAppDelegate.h"

@interface CoverViewController ()

@end

@implementation CoverViewController

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
//    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBarHidden = NO;
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setTintColor:[UIColor colorWithRed:0.33 green:0.66 blue:0.32 alpha:1.0]];
    UINavigationItem *n = [self navigationItem];
    [n setTitle:APP_TITLE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
