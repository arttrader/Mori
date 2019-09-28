//
//  MainMenuViewController.h
//  Mori
//
//  Created by Jon Hirota on 2013/03/17.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "TabLikeMenuViewController.h"

@interface MainMenuViewController : TabLikeMenuViewController
{
    BOOL bannerIsVisible;
    
}

@property (weak, nonatomic) IBOutlet UILabel *explLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property (weak, nonatomic) IBOutlet UIButton *RouletteBtn;
@property (weak, nonatomic) IBOutlet UIButton *SelectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *IconBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel1;
@property (weak, nonatomic) IBOutlet UILabel *textLabel2;
@property (weak, nonatomic) IBOutlet UILabel *textLabel3;

- (IBAction)onClickRoulette:(id)sender;
- (IBAction)onClickSelection:(id)sender;

@end
