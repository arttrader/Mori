//
//  ExplanationController.m
//  Mori
//
//  Created by Jon Hirota on 2013/04/27.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import "ExplanationController.h"

@interface ExplanationController ()

@end

@implementation ExplanationController

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
    // Do any additional setup after loading the view from its nib.
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        if ([UIApplication sharedApplication].statusBarHidden)
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 568)];
        else
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 548)];
    }

    [self.textView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self hideView];
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
