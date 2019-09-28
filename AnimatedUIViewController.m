//
//  AnimatedUIViewController.m
//  Hypno
//
//  Created by jhirota on 2012/12/06.
//
//  A View controller to create UIPopoverController like effect on non-iPad devices
//
//  Need work
//      Horizontal transition doesn't work yet
//      Curl up transition needs work
//      Add more transitions
//

#import "AnimatedUIViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MoriAppDelegate.h"
#import "TabLikeMenuViewController.h"

#define DEFAULT_TRANSITION 2;
#define DEFAULT_POSITION 0;
#define APPEARTIME .3;
#define CURLUPTIME .5;
#define HIDETIME .16

@interface AnimatedUIViewController()

@property (nonatomic,weak) UIImageView *screenShotView;

@end

@implementation AnimatedUIViewController

@synthesize delegate;
@synthesize transitionType;
@synthesize screenPosition;

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
    // if not initialized, set with default value
    if (!animAppearTime) {
        animAppearTime = APPEARTIME;
        animCurlTime = CURLUPTIME;
        animHideTime = HIDETIME;
        transitionType = DEFAULT_TRANSITION;
        screenPosition = DEFAULT_POSITION;
    }
    // for curl down animation
    /*
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContextWithOptions(screenRect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.screenShotView.layer renderInContext:context];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.screenShotView.image = screenShot;
    */
}

#pragma mark - to pop up this view
- (void)showView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect frame = self.view.frame;
    //NSLog(@"showView:scrn size %f, %f\n",screenRect.size.height,frame.size.height);
    switch (transitionType) {
        case 0: {// no transition
            frame.origin.x = (screenRect.size.width-frame.size.width)/2;
            if (![UIApplication sharedApplication].statusBarHidden) {
                //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                if (![delegate isKindOfClass:[TabLikeMenuViewController class]]) {
                    // a hack to account for a special case where it is called from AppDelegate when the top view includes a status bar
                    NSLog(@"not called from TabLikeMenuViewController\n");
                    frame.origin.y = (screenRect.size.height-frame.size.height+20)/2;
                } else
                    frame.origin.y = (screenRect.size.height-frame.size.height-20)/2;
            } else {
                //NSLog(@"accounted for status bar\n");
                frame.origin.y = (screenRect.size.height-frame.size.height)/2;
           }
        } break;
        case 1: { // Slide up based on y axis
            frame.origin.x = (screenRect.size.width-frame.size.width)/2;
            frame.origin.y = screenRect.size.height;
            self.view.frame = frame;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animAppearTime];
            if (!screenPosition) {
                if (![UIApplication sharedApplication].statusBarHidden)
                    frame.origin.y = (screenRect.size.height-frame.size.height-20)/2;
                else
                    frame.origin.y = (screenRect.size.height-frame.size.height)/2;
            } else {
                frame.origin.y = (screenRect.size.height-frame.size.height);
            }
            //NSLog(@"showView frame height %f  screen height %f \n", frame.size.height, screenRect.size.height);
        } break;
        case 2: { // Slide down based on y axis
            frame.origin.x = (screenRect.size.width-frame.size.width)/2;
            frame.origin.y = -screenRect.size.height;
            self.view.frame = frame;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animAppearTime];
            if (!screenPosition) {
                if (![UIApplication sharedApplication].statusBarHidden)
                    frame.origin.y = (screenRect.size.height-frame.size.height-20)/2;
                else
                    frame.origin.y = (screenRect.size.height-frame.size.height)/2;
            } else {
                frame.origin.y = (screenRect.size.height-frame.size.height);
            }
            [UIView animateWithDuration:animAppearTime delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            } completion:^(BOOL finished){}];
            //NSLog(@"showView frame height %f  screen height %f \n", frame.size.height, screenRect.size.height);
        } break;
        case 3: { // Slide left
            frame.origin.x = screenRect.size.width;
            if (![UIApplication sharedApplication].statusBarHidden)
                frame.origin.y = (screenRect.size.height-frame.size.height-20)/2;
            else
                frame.origin.y = (screenRect.size.height-frame.size.height)/2;
            self.view.frame = frame;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:animAppearTime];
            frame.origin.x = (screenRect.size.width-frame.size.width)/2;
        }break;
        case 5: { // Curl Up transition
            frame.origin.x = (screenRect.size.width-frame.size.width)/2;
            if (![UIApplication sharedApplication].statusBarHidden)
                frame.origin.y = (screenRect.size.height-frame.size.height-20)/2;
            else
                frame.origin.y = (screenRect.size.height-frame.size.height)/2;
            self.view.hidden = NO;
            [UIView transitionWithView:self.delegate.view
                    duration:animCurlTime
                    options: UIViewAnimationOptionTransitionCurlUp
                    animations:nil
                    completion:nil];
        } break;
        case 6: { // Curl Down transition
            frame.origin.x = (screenRect.size.width-frame.size.width)/2;
            if (![UIApplication sharedApplication].statusBarHidden)
                frame.origin.y = (screenRect.size.height-frame.size.height-20)/2;
            else
                frame.origin.y = (screenRect.size.height-frame.size.height)/2;
            self.view.hidden = NO;
            [UIView transitionWithView:self.delegate.view
                              duration:animCurlTime
                               options: UIViewAnimationOptionTransitionCurlDown
                            animations:nil
                            completion:nil];
        } break;
    }
    self.view.frame = frame;
    [UIView commitAnimations];
}
 
- (void)hideView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect frame = self.view.frame;
    if (transitionType && transitionType<5) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animHideTime];
    }

    switch (transitionType) {
        case 0:
        break;
        case 1: // Slide the view down off screen
            //NSLog(@"hideView called origin %f  height %f \n", frame.origin.y, screenRect.size.height);
            frame.origin.y = screenRect.size.height;
        break;
        case 2: // Slide the view up off screen
            //NSLog(@"hideView called origin %f  height %f \n", frame.origin.y, screenRect.size.height);
            frame.origin.y = -screenRect.size.height;
        break;
        case 3:
            //NSLog(@"hideView called origin %f  width %f \n", frame.origin.x, screenRect.size.width);
            frame.origin.x = screenRect.size.width;
        break;
        case 5: { // Curl Down transition
            frame.origin.y = screenRect.size.height;
            [UIView transitionWithView:self.delegate.view
                              duration:animCurlTime
                               options:UIViewAnimationOptionTransitionCurlDown
                            animations:^{ self.view.hidden = YES; }
                            completion:nil];
        } break;
        case 6: { // Curl Up transition
            frame.origin.y = screenRect.size.height;
            [UIView transitionWithView:self.delegate.view
                              duration:animCurlTime
                               options:UIViewAnimationOptionTransitionCurlUp
                            animations:^{ self.view.hidden = YES; }
                            completion:nil];
        } break;
    }
    self.view.frame = frame;
    
    // To autorelease the Msg, define stop selector
    if (transitionType && transitionType<5) {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView commitAnimations];
    }
    else [self animationDidStop:nil finished:YES context:nil];
}
/*
- (void)removeView
{
    [UIView transitionWithView:self.view
                      duration:animHideTime
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        self.view = self.screenShotView;
                    }
                    completion:^(BOOL finished){
                        //[self animationDidStop:nil finished:YES context:nil];
                        self.view.hidden = YES;
                    }];
}
*/
- (void)animationDidStop:(NSString*)animationID finished:(BOOL)finished context:(void *)context
{
    // Release
    [self willMoveToParentViewController:self.delegate];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
