//
//  InfoView.h
//  
//
//  Created by jhirota on 2012/11/13.
//
//

#import <UIKit/UIKit.h>
#import "AnimatedUIViewController.h"
#import "NADView.h"

@interface InfoView : AnimatedUIViewController<UIWebViewDelegate, UIActionSheetDelegate, NADViewDelegate>

@property (nonatomic, retain) NSString *siteURL;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forrwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadBtn;
@property (retain, nonatomic) IBOutlet NADView *nadView_;

- (IBAction)onClickClose:(id)sender;
- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickForward:(id)sender;
- (IBAction)onClickReload:(id)sender;

- (void)displaySite:(NSString *)urlStr;

@end