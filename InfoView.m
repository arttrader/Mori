//
//  InfoView.m
//
//
//  Created by jhirota on 2012/11/13.
//
//  Last updated by JHirota on 2013/2/21.

#import "InfoView.h"
#import "Reachability.h"
#import "DejalActivityView.h"
#import "MoriAppDelegate.h"

@implementation InfoView

@synthesize webView;
@synthesize siteURL;
@synthesize backBtn, forrwardBtn;
@synthesize nadView_;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.trackedViewName = @"プロフィール";
//    NSLog(@"loading InfoView\n");
    
    //[DejalActivityView activityViewForView:self.view];
    self.view.autoresizingMask = self.view.autoresizingMask | UIViewAutoresizingFlexibleHeight;
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        if ([UIApplication sharedApplication].statusBarHidden)
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 568)];
        else
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 548)];
    }
    
    // AdBanner handler
/*
    nadView_ = [nadView_ initWithFrame:CGRectMake(0,0,NAD_ADVIEW_SIZE_320x50.width,NAD_ADVIEW_SIZE_320x50.height)];
    [nadView_ setNendID:NEND_KEY spotID:NEND_ID];
    if ([nadView_ isKindOfClass:[NADView class]])
        NSLog(@"ad key checks out OK\n");
    else
        NSLog(@"ad key does not match\n");
    nadView_.delegate = self;
    nadView_.rootViewController = self;
    [nadView_ load];
*/    
    self.transitionType = 0;
    webView.delegate = self;
    [self updateToolbarItems];
}


#pragma mark - NADView delegate

- (void)viewWillDisappear:(BOOL)animated {
    [nadView_ pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [nadView_ resume];
}

- (void) nadViewDidFinishLoad:(NADView *)adView
{
    NSLog(@"delegate nadViewDidFinishLoad:");
    nadView_.delegate = self;
}

- (void) nadViewDidReceiveAd:(NADView *)adView
{
    NSLog(@"delegate nadViewDidReceiveAd:");
}

-(void)nadViewDidFailToReceiveAd:(NADView *)adView {
    NSLog(@"delegate nadViewDidFailToLoad:");
}

- (IBAction)onClickBack:(id)sender
{
    [webView goBack];
}

- (IBAction)onClickForward:(id)sender
{
    [webView goForward];
}

- (IBAction)onClickReload:(id)sender
{
    [webView reload];
}

- (IBAction)onClickClose:(id)sender
{
    [self hideView];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGRect frame = self.view.frame;
        frame.origin.x = (screenRect.size.width-frame.size.width)/2;
        if ([UIApplication sharedApplication].statusBarHidden)
            frame.origin.y = screenRect.size.height;
        else
            frame.origin.y = screenRect.size.height-20;
        self.view.frame = frame;
    }
    return self;
}

- (void)displaySite:(NSString *)urlStr
{
    Reachability * reach = [Reachability reachabilityForInternetConnection];    
    if([reach isReachable])
    {
        webView.hidden = NO;
        webView.backgroundColor = [UIColor clearColor];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *req = [NSURLRequest requestWithURL:url];
        [webView loadRequest:req];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"NoInternetKey",@"") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)viewDidUnload
{
    webView = nil;
    //closeWebBtn = nil;
    [self setBackBtn:nil];
    [self setForrwardBtn:nil];
    [self setReloadBtn:nil];
    nadView_.delegate = nil;
    nadView_.rootViewController = nil;
    nadView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [DejalBezelActivityView activityViewForView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [DejalBezelActivityView removeViewAnimated:YES];
    [self updateToolbarItems];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [DejalBezelActivityView removeViewAnimated:YES];
    [self updateToolbarItems];
}

- (void)updateToolbarItems {
    self.backBtn.enabled = self.webView.canGoBack;
    self.forrwardBtn.enabled = self.webView.canGoForward;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
