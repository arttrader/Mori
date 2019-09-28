//
//  RSSViewController.h
//  Kossori
//
//  Created by jhirota on 2013/03/22.
//  Copyright (c) 2013年 J Hirota. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AnimatedUIViewController.h"
#import "InfoView.h"
//#import "TabLikeMenuViewController.h"
#import "NewsCell.h"

#define FEED_URL @"http://yohaku.narasaku.jp/?feed=rss2"

@interface RSSViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NADViewDelegate>
{
    BOOL autoRefresh;
    NSInteger numItem2Show;
    InfoView *infoView;
}

@property NSInteger displayOption; // 0 Step-mail type display, 1 News display

@property (retain, nonatomic) IBOutlet UITableView *rssTable;
@property (nonatomic, strong) UINib *tableCellLoader;
@property (retain, nonatomic) IBOutlet NADView *nadView_;

+ (void)showReminder:(NSString *)text;
+ (void)scheduleNotification4Tomorrow:(NSInteger) interval;

- (IBAction)onClickClose:(id)sender;
- (IBAction)onClickClearNotification:(id)sender;
- (IBAction)onClickUpdate:(UIButton *)sender;

@end
