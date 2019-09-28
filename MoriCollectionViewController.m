//
//  MoriCollectionViewController.m
//  Mori
//
//  Created by Jon Hirota on 2013/02/05.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import "CardItem.h"
#import "CHCSV.h"
#import "MoriCollectionViewController.h"
#import "HeaderView.h"
#import "MoriCollectionCell.h"
#import "MoriDetailViewController.h"
#import "MoriAppDelegate.h"

#define NUMBEROFICONS 12

@interface MoriCollectionViewController () {
    NSMutableArray *cards;
    BOOL started;
}
@end

@implementation MoriCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

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
	// Do any additional setup after loading the view.
    [self loadData];
    
    // contentViewにcellのクラスを登録
    [self.collectionView registerClass:[MoriCollectionCell class] forCellWithReuseIdentifier:@"Cell"];
    
    // contentViewにheaderのnibを登録
    [self.collectionView registerClass:[HeaderView class] forCellWithReuseIdentifier:@"Header"];

    selectedCardis = [[NSMutableArray alloc] initWithCapacity:9];

    for (NSInteger i=0; i<NUMBEROFICONS; i++) {
        NSInteger x;
        BOOL duplicate = YES;
        while (duplicate) {
            x = arc4random() % 63;
            duplicate = NO;
            for (NSNumber *n in selectedCardis) {
                if (x==[n intValue]) duplicate = YES;
            }
        }
        //NSLog(@"Random number %i\n", x);
        NSNumber* xWrapped = [NSNumber numberWithInt:x];

        [selectedCardis addObject:xWrapped];
    }
/*
    // setup recognizers for swipe back
    UISwipeGestureRecognizer* swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGestureRecognized:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRecognizer.delegate = (id)self; // Very important
    [self.view addGestureRecognizer:swipeRecognizer];
*/
}

- (void)swipeGestureRecognized:(UISwipeGestureRecognizer *)recognizer
{
    //NSLog(@"Gesture recognized\n");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)collectionView:collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedItemIndex = [selectedCardis[indexPath.row] intValue];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return NUMBEROFICONS;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoriCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSInteger i = [selectedCardis[indexPath.row] intValue];
    NSLog(@"card index %i\n", i);
    //CardItem *card = cards[i];

    cell.cellImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%da.png", i+1]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    //headerView.label.text = [self.titles objectAtIndex:indexPath.section];
    return headerView;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //[selectedCardis[indexPath.row] intValue];
        CardItem *object = cards[selectedItemIndex];
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
            if (!cards) {
                cards = [[NSMutableArray alloc] init];
            }
            CardItem *card = [CardItem alloc];
            [card setCardData:titleStr imageData:imageStr descData:descStr];
            [cards addObject:card];
        }
        NSLog(@"%d items loaded\n", cards.count);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCellImage:nil];
    [self setCollectionView:nil];
    [super viewDidUnload];
}
@end
