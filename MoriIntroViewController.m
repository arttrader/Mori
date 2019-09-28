//
//  MoriIntroViewController.m
//  Mori
//
//  Created by Jon Hirota on 2013/03/29.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import "MoriIntroViewController.h"
#import "ExplanationController.h"
#import "MoriAppDelegate.h"

@interface MoriIntroViewController ()

@end

@implementation MoriIntroViewController

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
    [self.textView flashScrollIndicators];
    self.textView.delegate = self;
    if (g_IS_IPHONE_5_SCREEN) {
        //CGRect originalViewRect = self.backgroundImage.bounds;
        CGRect largerFrame = self.view.bounds;
        largerFrame.size.width = largerFrame.size.width * largerFrame.size.height / 460.0f;
        largerFrame.origin.x = - (largerFrame.size.width - self.view.bounds.size.width) / 2.0f;
        largerFrame.origin.y = 20.0f;
        self.backgroundImage.bounds = largerFrame;
    }
}

- (IBAction)onClickNextBtn:(id)sender {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSInteger currentScrollPos = self.textView.contentOffset.y;
    //    NSLog(@"scroll pos %d contentoffset %f", currentScrollPos, self.scrollContent.bounds.size.height-self.scrollView.bounds.size.height);
/*    if (currentScrollPos >= self.scrollContent.bounds.size.height-self.textView.bounds.size.height-1) {
        [self hideBtn];
    }
    else {
        [self showBtn];
    }
*/
}

- (IBAction)onClickScroll:(id)sender
{
    NSInteger currentScrollPos = self.textView.contentOffset.y + self.textView.bounds.size.height  - 20;
    [self.textView scrollRectToVisible:CGRectMake(0,currentScrollPos,260,self.textView.bounds.size.height) animated:YES];
    //    if (currentScrollPos > self.scrollContent.bounds.size.height-self.scrollView.bounds.size.height)
    //        [self hideBtn];
}



- (void)showBtn
{
    [UIView animateWithDuration:1.2
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{self.nextBtn.alpha = 1.0;}
                     completion:nil];
}

- (void)hideBtn
{
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{self.nextBtn.alpha = 0.0;}
                     completion:nil];
}



- (IBAction)onClickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickAuthor:(id)sender {
    if (expView == nil) {
        expView = [[ExplanationController alloc] init];
        expView.delegate = (id)self;
    }
    [self addChildViewController:expView]; // iOS 5 and later, good practice to add to parent controller
    [self.view addSubview:expView.view];
    [expView showView];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    [self setNextBtn:nil];
    [super viewDidUnload];
}
@end
