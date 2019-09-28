//
//  MoriMasterViewController.m
//  Mori
//
//  Created by jhirota on 2012/09/19.
//  Copyright (c) 2012年 J Hirota. All rights reserved.
//

#import "CardItem.h"
#import "CHCSV.h"
#import "MoriMasterViewController.h"
#import "MoriDetailViewController.h"
#import "MoriAppDelegate.h"

#define SCROLL_SPEED 10 //items per second, can be negative or fractional
//#define MORI_CYLINDER

@interface MoriMasterViewController () {
    NSMutableArray *_cards;
    BOOL started;
}

@property (nonatomic, assign) NSTimeInterval lastTime;

@end


@implementation MoriMasterViewController

@synthesize carousel;
@synthesize adView;
@synthesize lastTime;
@synthesize backgroundImg;


#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadData];
    UINavigationItem *n = [self navigationItem];
    [n setTitle:APP_TITLE];
    //UINavigationBar *bar = [self.navigationController navigationBar];
    //[bar setTintColor:[UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0]];

    // Log fonts
/*    for (NSString *family in [UIFont familyNames])
    {
        NSLog(@"Font family %@:", family);
        for (NSString *font in [UIFont fontNamesForFamilyName:family])
            NSLog(@"    %@", font);
    }
*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    CGFloat yOffset = 0;
    MoriAppDelegate *appDelegate = (MoriAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.optionPurchased) {
        bannerIsVisible = NO;
        adView.hidden = YES;
        CGRect btnRect = self.startStopBtn.frame;
        if (g_IS_IPHONE_5_SCREEN) {
            btnRect.origin.y = 568 - 20 - btnRect.size.height;
        } else {
            btnRect.origin.y = 480 - btnRect.size.height;
        }
        self.startStopBtn.frame = btnRect;
    } else {
        NSLog(@"Option not purchased\n");
//        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
//        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
        adView.delegate = (id)self;
    }
    yOffset = 20;
    if (g_IS_IPHONE_5_SCREEN) yOffset += 10;
    if (!self.displayType) self.displayType = 1;
    sound1 = NULL;
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"chime"
                                              withExtension:@"m4a"];
    AudioServicesCreateSystemSoundID((CFURLRef)CFBridgingRetain(soundURL), &sound1);
    //configure carousel
    if (self.displayType==1) {
        self.expTextLabel.text = @"スタートボタンを押してください。";
        carousel.type = iCarouselTypeCylinder;
        CGSize offset = CGSizeMake(0.0f, -230.0f);
        carousel.viewpointOffset = offset;
        offset = CGSizeMake(0.0f, -180.0f+yOffset);
        carousel.contentOffset = offset;
        carousel.scrollEnabled = NO;
        self.startStopBtn.hidden = NO;
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"bgsky" ofType:@"jpg"];
        backgroundImg.image = [UIImage imageWithContentsOfFile:imagePath];
        backgroundImg.alpha = 1.0;
        imagePath = [[NSBundle mainBundle] pathForResource:@"startbtn" ofType:@"png"];
        [self.startStopBtn setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    }
    else if(self.displayType==2) {
        self.expTextLabel.text = @"カードをパラパラとめくり、これだと感じたカードを選んで下さい。";
        carousel.type = iCarouselTypeCoverFlow2;
        CGSize offset = CGSizeMake(0.0f, -60.0f+yOffset);
        carousel.viewpointOffset = offset;
        carousel.scrollEnabled = YES;
        self.startStopBtn.hidden = YES;
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"bgwater" ofType:@"jpg"];
        backgroundImg.image = [UIImage imageWithContentsOfFile:imagePath];
        backgroundImg.alpha = 0.7;
    }
    self.startStopBtn.alpha = 0.0;
    self.startStopBtn.enabled = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(showBtn)
                                   userInfo:nil
                                    repeats:NO];
    started = NO;
    //[self onClickStart:self];
}

- (void)showBtn
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{self.startStopBtn.alpha = 1; self.startStopBtn.enabled = YES;}
                     completion:nil];
    //[self onClickStart:self];
}

- (void)hideBtn
{
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{self.startStopBtn.alpha = 0.0;}
                     completion:nil];
}

- (IBAction)onClickStart:(id)sender
{
    if (!started) {
        AudioServicesPlaySystemSound(sound1);
        started = YES;
        //[self.startStopBtn setTitle:@"ストップ" forState:UIControlStateNormal];
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"stopbtn" ofType:@"png"];
        [self.startStopBtn setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        self.carousel.decelerationRate = 1.0;
        [self.carousel manualStart:10.0 + 10*rand()/RAND_MAX];
        self.expTextLabel.text = @"では、深呼吸して、心を空にして下さい。そしてゆっくりとストップボタンを押してください。";
    }
    else {
        [self hideBtn];
        self.carousel.decelerationRate = 0.99;
        [self.carousel startDecelerating];
    }
}

- (void)scrollStep
{
    //calculate delta time
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    float delta = lastTime - now;
    lastTime = now;
    
    //don't autoscroll when user is manipulating carousel
    if (!carousel.dragging && !carousel.decelerating)
    {
        //scroll carousel
        carousel.scrollOffset += delta * (float)(SCROLL_SPEED);
    }
}

- (void)carouselDidEndDecelerating:(id)sender
{
    NSLog(@"carousel stopped\n");
    if (self.displayType==1)
        [self buttonTapped:self];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    NSLog(@"carousel dragged\n");
    AudioServicesPlaySystemSound(sound1);
    started = YES;
}

- (void)viewDidUnload
{
    [self setStartStopBtn:nil];
    [self setAdView:nil];
    [self setBackgroundImg:nil];
    [self setExpTextLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.carousel = nil;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!bannerIsVisible)
    {
//        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
//        banner.frame = CGRectOffset(banner.frame, 0, 50);
//        [UIView commitAnimations];
        bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (bannerIsVisible)
    {
//        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
//        banner.frame = CGRectOffset(banner.frame, 0, -50);
//        [UIView commitAnimations];
        bannerIsVisible = NO;
    }
}

#pragma mark -
#pragma mark UIActionSheet methods


#pragma mark -
#pragma mark iCarousel methods

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    if (self.displayType==2) { // for Selecting a card
        UIButton *button = (UIButton *)view;
        if (button == nil) 
        {
            //no button available to recycle, so create new one
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0.0f, 0.0f, 100.0f, 220.0f);
            //[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //button.titleLabel.font = [button.titleLabel.font fontWithSize:50];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        //[button setBackgroundImage:((CardItem *)_cards[index]).thumbnail forState:UIControlStateNormal];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"cardback" ofType:@"jpg"];
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
        return button;
	}
    else { // for Roulette
        UIImageView *imageView = (UIImageView *)view;
        if (imageView == nil)
        {
            //don't do anything specific to the index within
            //this `if (view == nil) {...}` statement because the view will be
            //recycled and used with other index values later
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 160)];
            imageView.image = ((CardItem *)_cards[index]).thumbnail;
            
        }
        else
        {
            //get a reference to the label in the recycled view
            imageView.image = ((CardItem *)_cards[index]).thumbnail;
        }
         return imageView;
    }
	//set button label
	//[button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
    NSLog(@"View for item at index %d \n", index);
	
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.02f;
        }
        case iCarouselOptionFadeMin:
            return -0.2f;
        case iCarouselOptionFadeMax:
            return -0.2f;
        case iCarouselOptionFadeRange:
            return 8.0f;
        default:
        {
            return value;
        }
    }
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _cards.count;
    NSLog(@"Number of items %d \n", _cards.count);
}

- (BOOL)carouselWillBeginDecelerating
{
    return YES;
}


#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(id)sender
{
    NSLog(@"touch Up %d\n", carousel.currentItemIndex);

    if (started) {
        [self performSegueWithIdentifier:@"showDetail" sender:sender];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        CardItem *object = _cards[carousel.currentItemIndex];
        [[segue destinationViewController] setDetailItem:object];
    }
}


- (void)loadData
{
    NSString *filename = @"MoriData";
    
    //NSLog(@"Loading data...\n");
    NSError *error;
    
    NSString * csvFile = [[NSBundle mainBundle] pathForResource:filename ofType:@"csv"]; //path to the CSV file
    NSArray * contents = [NSArray arrayWithContentsOfCSVFile:csvFile
                                                    encoding:NSShiftJISStringEncoding
                                                       error:&error];
    if (contents == nil) {
        NSLog (@"Error %@", error);
    } else {
        for(NSArray *lineArr in contents)
        {
            //NSLog(@"Line: %@\n", lineStr);
            NSString *titleStr = [lineArr[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
            NSString *descStr = [lineArr[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
            NSString *imageStr = [lineArr[2] stringByReplacingPercentEscapesUsingEncoding:NSUTF16StringEncoding];
            
            //NSLog(@"loadData: %@  %@ \n", titleStr, imageStr);
            
            /*Add value for each column into dictionary*/
            if (!_cards) {
                _cards = [[NSMutableArray alloc] init];
            }
            CardItem *card = [CardItem alloc];
            [card setCardData:titleStr imageData:imageStr descData:descStr];
            [_cards addObject:card];
        }
        NSLog(@"%d items loaded\n", _cards.count);
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    else
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
}

@end
