//
//  TabLikeMenuViewController.m
//
//
//  Created by jhirota on 2012/12/20.
//  Copyright (c) 2012年 jhirota. All rights reserved.
//
//  Each tab buttons in Storyboard need to be linked for this to work.
//
//  2013-1-30 Video player function is integrated.
//
//  2013-2-14 Banner handling code is integrated.
//  UIImage and UIButton need to be created in Storyboard,
//  and the property bannerImage, and the handler adbannerClicked should be linked.
//
//  2013-2-18 FB & Twitter code is moved here.
//  FB is all new with twitter like interface.
//  2013-2-22 Line share is added.

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TabLikeMenuViewController.h"
#import "MoriAppDelegate.h"
#import "MediaPlayer/MediaPlayer.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import "DEFacebookComposeViewController.h"

#define MAINMENU_INDEX 5 // for Manemeiku, may need to be changed for others
#define ICON_IMAGE @"bg1.png"
#define FBPAGE_URL @"http://www.facebook.com/pages/yohaku"

@implementation NSString(stringWithURLEncoding)

- (NSString *)stringWithURLEncoding
{
    // ref: http://blog.daisukeyamashita.com/post/1686.html
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                        NULL,
                                                                        (CFStringRef)self,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                        kCFStringEncodingUTF8 );
}

@end

@interface TabLikeMenuViewController ()

@end

@implementation TabLikeMenuViewController

//@synthesize nadView_;

- (void)initBanner
{
    // AdBanner handler
/*
    nadView_ = [nadView_ initWithFrame:CGRectMake(0,0,NAD_ADVIEW_SIZE_320x50.width,NAD_ADVIEW_SIZE_320x50.height)];
    
    [nadView_ setNendID:NEND_KEY spotID:NEND_ID];
    if ([nadView_ isKindOfClass:[NADView class]])
        NSLog(@"ad key checks out OK\n");
    else
        NSLog(@"ad key does not match\n");
    
    nadView_.delegate = self;
    
    [nadView_ load];
*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.isVideoFullscreen = NO;
//    [self initBanner];
    
    // setup recognizers for swipe back
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognized:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRecognizer.delegate = (id)self; // Very important
    [self.view addGestureRecognizer:swipeRecognizer];

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"displayRSS %i   displayNews %i\n", self.displayRSS, self.displayNews);
    if (self.displayRSS) {
        if (rssView == nil) {
            rssView = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"RSSViewController"];
        }
        NSLog(@"showing RSS View...\n");
        [self presentViewController:rssView animated:YES completion:nil];
        self.displayRSS = NO;
        if (self.navigationController.viewControllers.count>1) {
            [self.navigationController popViewControllerAnimated:NO];
        }
    } else if (self.displayNews) {
        NSLog(@"showing Web View...\n");
//        [self showSite:NEWS_URL];
        self.displayNews = NO;
        if (self.navigationController.viewControllers.count==1) {
        //if (![self.navigationController.viewControllers[0] isEqual:self]) {
            // this means it is called from AppDelegate so get back to the first screen
            NSLog(@"popping delegate view controller  count=%i\n",self.navigationController.viewControllers.count);
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
}


#pragma mark - NADView delegate
/*
- (void)viewWillDisappear:(BOOL)animated {
    [nadView_ pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [nadView_ resume];
}

- (void) nadViewDidFinishLoad:(NADView *)adView
{
    //NSLog(@"delegate nadViewDidFinishLoad:");
    nadView_.delegate = self;
}

- (void) nadViewDidReceiveAd:(NADView *)adView
{
    //NSLog(@"delegate nadViewDidReceiveAd:");
}

-(void)nadViewDidFailToReceiveAd:(NADView *)adView
{
    //NSLog(@"delegate nadViewDidFailToLoad:");
}
*/

#pragma mark - Video Play handler
/*
- (void)playVideo:(NSString*)fileName
{
    // Initialize the movie player view controller with a video URL string
    
    MPMoviePlayerViewController *playerVC = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:fileName]];
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:playerVC
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerVC.moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerVC.moviePlayer];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:)
    //                                             name:MPMoviePlayerWillEnterFullscreenNotification
    //                                           object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:)
    //                                             name:MPMoviePlayerDidExitFullscreenNotification
    //                                           object:nil];
    
    // Set the modal transition style of your choice
    playerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    // Present the movie player view controller
    [self presentModalViewController:playerVC animated:YES];
    
    MoriAppDelegate *appDelegate = (MoriAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isVideoFullscreen = YES;
    // Start playback
    [playerVC.moviePlayer prepareToPlay];
    [playerVC.moviePlayer play];
}

- (void)movieFinishedCallback:(NSNotification *)notification {
    NSLog(@"VideoPlay ended\n");
    //self.videoView.view.hidden = YES;
    NSNumber *finishReason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    switch([finishReason intValue]){
        case MPMovieFinishReasonPlaybackEnded:{
            NSLog(@"Played till end\n");
            break;
        }
        case MPMovieFinishReasonUserExited:{
            NSLog(@"Done button pressed\n");
            break;
        }
        case MPMovieFinishReasonPlaybackError:{
            NSLog(@"Error\n");
            break;
        }
    }
    MoriAppDelegate *appDelegate = (MoriAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isVideoFullscreen = NO;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (!UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        NSLog(@"Landscape, do animation with modal view\n");
        UIViewController *c = [[UIViewController alloc] init];
        [self presentModalViewController:c animated:NO];
        [self dismissModalViewControllerAnimated:NO];
    }
    [self dismissModalViewControllerAnimated:YES];
}
*/


#pragma mark - Menu Button handler

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickIntro:(id)sender
{
    if (rssView == nil) {
        rssView = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"RSSViewController"];
    }
    [self presentViewController:rssView animated:YES completion:nil];
    //UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:MAINMENU_INDEX];
    //[self.navigationController popToViewController:prevVC animated:YES];
}

- (IBAction)onClickInfo:(id)sender
{
    [self showSite:SITE_URL];
}
/*
- (IBAction)onClickShare:(id)sender
{
    if (shareView == nil) {
        shareView = [[ShareView alloc] init];
        shareView.delegate = (id)self;
    }
    [self addChildViewController:shareView];
    [self.view addSubview:shareView.view];
    [shareView showView];
}

- (IBAction)onClickGift:(id)sender
{
    if (giftView == nil) {
        giftView = [self.storyboard instantiateViewControllerWithIdentifier:@"GiftView"];
        giftView.delegate = (id)self;
    }
    [self addChildViewController:giftView];
    [self.view addSubview:giftView.view];
    [giftView showView];
}
*/
- (void)swipeGestureRecognized:(UISwipeGestureRecognizer *)recognizer
{
    //NSLog(@"Gesture recognized\n");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showSite:(NSString *)url
{
    if (infoView == nil) {
        infoView = [[InfoView alloc] init];
        infoView.delegate = (id)self;
    }
    [self addChildViewController:infoView]; // iOS 5 and later, good practice to add to parent controller
    [self.view addSubview:infoView.view];
    [infoView showView];
    [infoView displaySite: url];
}

#pragma make ShareViewDelegate
/*　sharing with friends feature, needed for ShareView */
- (void)shareWithFB
{
    DEFacebookComposeViewController * fbViewComposer = [[DEFacebookComposeViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [fbViewComposer setInitialText:NSLocalizedString(@"TweetMessageKey",nil)];
    [fbViewComposer addImage:[UIImage imageNamed:ICON_IMAGE]];
    //[compose addURL:APP_URL];
    [fbViewComposer setCompletionHandler:^(DEFacebookComposeViewControllerResult result) {
        switch (result) {
            case DEFacebookComposeViewControllerResultCancelled:
                NSLog(@"Facebook Result: Cancelled");
                break;
            case DEFacebookComposeViewControllerResultDone:
                NSLog(@"Facebook Result: Sent");
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    [[self navigationController] presentViewController:fbViewComposer animated:YES completion:nil];
}

- (void)shareWithTwitter
{
    // Set up the built-in twitter composition view controller.
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
    [tweetViewController setInitialText:NSLocalizedString(@"TweetMessageKey",nil)];
    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSString *output;
        
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                // The cancel button was tapped.
                output = NSLocalizedString(@"TweetCancelKey",nil);
                break;
            case TWTweetComposeViewControllerResultDone:
                // The tweet was sent.
                output = NSLocalizedString(@"TweetDoneKey",nil);
                // show message that tweet was sent successfully
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [[self navigationController] presentViewController:tweetViewController animated:YES completion:nil];
}

- (void)shareViaLine
{
    NSString *contentType = @"text";
    NSString *contentKey = [NSLocalizedString(@"TweetMessageKey", nil) stringWithURLEncoding];
    NSString *urlString = [NSString
                           stringWithFormat: @"http://line.naver.jp/R/msg/%@/?%@",
                           contentType, contentKey];
    
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)shareWithFriend
{
    UIActionSheet *actionShareFriend = [[UIActionSheet alloc]
                                        initWithTitle:NSLocalizedString(@"ShareKey",nil)
                                        delegate:(id)self
                                        cancelButtonTitle:NSLocalizedString(@"CancelKey",nil)
                                        destructiveButtonTitle:NSLocalizedString(@"eMailKey",nil)
                                        otherButtonTitles:@"SMS", nil];
    [actionShareFriend showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionsheet called");
    if ( buttonIndex == 0 )
        [self shareWithEMail];
    else if ( buttonIndex == 1 )
        [self shareWithSMS];
}

- (void)shareWithEMail
{
    //NSLog(@"shareWithEMail called");
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    [mailer setSubject:NSLocalizedString(@"ToFriendsMessTitleKey",nil)];
    [mailer setMessageBody:NSLocalizedString(@"ToFriendsMessKey",nil) isHTML:NO];
    mailer.mailComposeDelegate = (id)self;
    [[self navigationController] presentViewController:mailer animated:YES completion:nil];
}

- (void)shareWithSMS
{
    //NSLog(@"shareWithSMS called");
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messager = [[MFMessageComposeViewController alloc] init];
        [messager setBody:NSLocalizedString(@"ToFriendsMessKey",nil)];
        messager.messageComposeDelegate = (id)self;
        [[self navigationController] presentViewController:messager animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"たぶんSMSを使用できないデバイスをご使用中です。" delegate:self cancelButtonTitle:@"分かりました" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - facebook integration
- (IBAction)likesCheck:(id)sender {
    
    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
                                                  graphPath:@"me/likes"
                                                 parameters:[NSMutableDictionary dictionary]
                                                 HTTPMethod:@"GET"];
    
    [newConnection addRequest:request completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error)
        {
            NSLog(@"error %@", result);
        } else {
            BOOL liked = NO;
            NSLog(@"result %@", result);
            if ([result isKindOfClass:[NSDictionary class]]){
                NSArray *likes = [result objectForKey:@"data"];
                
                for (NSDictionary *like in likes) {
                    if ([[like objectForKey:@"id"] isEqualToString:@"__page_id__"]) {
                        NSLog(@"like");
                        liked = YES;
                        break;
                    }
                }
            }
            
            if (!liked) {
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://page/__page_id__"]]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://page/__page_id__"]];
                } else {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FBPAGE_URL]];
                }
            }
        };
    }];
    
    [newConnection start];
}


#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}

#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [[self navigationController] dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    shareView.delegate = nil;
//    shareView = nil;
//    giftView.delegate = nil;
//    giftView = nil;
    infoView.delegate = nil;
    infoView = nil;
}

- (void) dealloc {
//    [nadView_ setDelegate:nil];
//    nadView_ = nil;
//    shareView.delegate = nil;
//    shareView = nil;
//    giftView.delegate = nil;
//    giftView = nil;
    infoView.delegate = nil;
    infoView = nil;
}

- (void)viewDidUnload {
//    nadView_.delegate = nil;
//    nadView_.rootViewController = nil;
//    nadView_ = nil;
    [super viewDidUnload];
}

@end
