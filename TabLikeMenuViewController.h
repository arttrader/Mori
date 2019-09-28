//
//  TabLikeMenuViewController.h
//
//
//  Created by jhirota on 2012/12/20.
//  Copyright (c) 2012年 jhirota. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ShareView.h"
//#import "GiftView.h"
#import "InfoView.h"
#import "RSSViewController.h"
//#import "GAI.h"
#import "NADView.h"

@interface TabLikeMenuViewController : UIViewController<NADViewDelegate>
{
    //ShareView *shareView;
    //GiftView *giftView;
    InfoView *infoView;
    RSSViewController *rssView;
    NSInteger bannerSelection;
}

@property (nonatomic) BOOL displayNews;
@property (nonatomic) BOOL displayRSS;
//@property (nonatomic, retain) IBOutlet NADView *nadView_;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickIntro:(id)sender;
- (IBAction)onClickInfo:(id)sender;
//- (IBAction)onClickShare:(id)sender;
//- (IBAction)onClickGift:(id)sender;

//- (void)playVideo:(NSString*)fileName;
//- (void)shareWithFriend;
//- (void)shareWithFB;
//- (void)shareWithTwitter;
//- (void)shareViaLine;
//- (void)showSite:(NSString *)url;

@end
