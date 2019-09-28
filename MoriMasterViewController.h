//
//  MoriMasterViewController.h
//  Mori
//
//  Created by jhirota on 2012/09/19.
//  Copyright (c) 2012年 J Hirota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AudioToolbox/AudioToolbox.h>
#import "iCarousel.h"
#import "TabLikeMenuViewController.h"

@class CardItem;

@interface MoriMasterViewController : TabLikeMenuViewController <iCarouselDataSource, iCarouselDelegate , ADBannerViewDelegate>
{
    BOOL bannerIsVisible;
    SystemSoundID *sound1;
}

@property (weak, nonatomic) IBOutlet ADBannerView *adView;
@property NSInteger displayType;

@property (weak, nonatomic) IBOutlet UILabel *expTextLabel;
@property IBOutlet iCarousel *carousel;
@property (weak, nonatomic) IBOutlet UIButton *startStopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

- (IBAction)onClickStart:(id)sender;

@end
