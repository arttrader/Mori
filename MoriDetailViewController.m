//
//  MoriDetailViewController.m
//  Mori
//
//  Created by jhirota on 2012/09/19.
//  Copyright (c) 2012年 J Hirota. All rights reserved.
//

#import "MoriDetailViewController.h"
#import "CardItem.h"


@interface MoriDetailViewController ()
- (void)configureView;
@end

@implementation MoriDetailViewController
@synthesize adView;

#pragma mark - Managing the detail item

- (void)setDetailItem:(CardItem *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {

        UIFont *bFont = [UIFont fontWithName:@"azukifontP" size:16.0];
        self.cardText.font = bFont;
        self.cardText.text = [self.detailItem desc];
        self.cardImage = [self.cardImage initWithImage:[self.detailItem image]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    //adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    //adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    adView.hidden = NO;
    adView.delegate = (id)self;
    originalViewRect = self.cardImage.frame;
    imgExpanded = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"title length %i", self.detailItem.title.length);
    //if (self.navigationController.navigationBar.titleTextAttributes)
    
    if (self.detailItem.title.length>9) {
        autoScrollLabel=[[AutoScrollLabel alloc] initWithFrame:CGRectMake(116, 13, 194, 20)];
        autoScrollLabel.textColor = [UIColor whiteColor];
        autoScrollLabel.font = [UIFont boldSystemFontOfSize: 19.0f];
    //    autoScrollLabel.shadowOffset = CGSizeMake(0, 1);
        autoScrollLabel.text = self.detailItem.title;
        [self.navigationController.navigationBar addSubview:autoScrollLabel];
    } else
        [self.navigationItem setTitle:self.detailItem.title];
    [self.cardText flashScrollIndicators];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [autoScrollLabel removeFromSuperview];
    autoScrollLabel= nil;    
}

- (IBAction)onClickImage:(id)sender
{
    if (imgExpanded) {
        [UIView animateWithDuration:0.5f animations:^{
            self.cardImage.frame = originalViewRect;
            self.cardText.alpha = 1.0f;
            self.imgButton.bounds = originalViewRect;
            imgExpanded = NO;
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            CGRect largerFrame = self.view.bounds;
            largerFrame.size.width = largerFrame.size.width * largerFrame.size.height/originalViewRect.size.height;
            self.imgButton.bounds = largerFrame;
            largerFrame.origin.x = - (largerFrame.size.width - self.view.bounds.size.width) / 2;
            self.cardImage.frame = largerFrame;
            self.cardText.alpha = 0.0f;
            imgExpanded = YES;
            
        }];
    }
}

- (void)viewDidUnload
{
    [self setCardImage:nil];
    [self setCardText:nil];
    [self setCardText:nil];
    [self setAdView:nil];
    [self setImgButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
