//
//  RSSViewController.m
//  
//
//  Created by jhirota on 2013/03/22.
//  Copyright (c) 2013年 J Hirota. All rights reserved.
//

#import "RSSViewController.h"

//#import "TableHeaderView.h"

#import "DejalActivityView.h"
#import "RSSLoader.h"
#import "RSSItem.h"

#import "MoriAppDelegate.h"

#define NUMRSSSHOWN @"NumNewsShown"
#define REMINDERNOTIF_KEY1 @"kYohakuNotificationDataKey"
#define DATELASTITEM @"DateLastItemAdded"

@interface RSSViewController ()
{
    NSArray *_objects;
    NSMutableArray *displayFeed;
    NSURL* feedURL;
    UIRefreshControl* refreshControl;
    NSInteger numItems;
}
@end


@implementation RSSViewController
@synthesize rssTable, displayOption;
@synthesize nadView_;

+ (void)showReminder:(NSString *)text {
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新しいレッスンが届いているよ"
                                                        message:text delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
	[alertView show];
}

+ (void)scheduleNotification4Tomorrow:(NSInteger) interval {
    NSLog(@"Schedule notification");
    // schedule new notification for tomorrow
    // Increment the time components by interval
    NSDate *date = [NSDate date];
    // Create and initialize date component instance
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // 時間は６時配信に設定する
    [comps setMinute:interval]; // change this to day later
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:comps
                       toDate:date options:0];
    
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    notif.fireDate = newDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = @"新着記事が届いています";
    notif.alertAction = @"今見る";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 1;
    notif.repeatInterval = NSMinuteCalendarUnit; // for testing set to minute, change this to NSDayCalendarUnit
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"1"
                                                         forKey:REMINDERNOTIF_KEY1];
    notif.userInfo = userDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.rssTable.delegate = self;
    self.rssTable.dataSource = self;

/*
    // AdBanner handler
    nadView_ = [nadView_ initWithFrame:CGRectMake(0,0,NAD_ADVIEW_SIZE_320x50.width,NAD_ADVIEW_SIZE_320x50.height)];
    [nadView_ setNendID:NEND_KEY spotID:NEND_ID];
//    if ([nadView_ isKindOfClass:[NADView class]])
//        NSLog(@"ad key checks out OK\n");
//    else
//        NSLog(@"ad key does not match\n");
    nadView_.delegate = self;
    nadView_.rootViewController = self;
    [nadView_ load];
*/
    autoRefresh = NO;
    //[self configureView];
}

- (void)showView
{
    [self configureView];
//    [super showView];
}


#pragma mark - NADView delegate

- (void)viewWillDisappear:(BOOL)animated {
    [nadView_ pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [nadView_ resume];
    [self configureView];
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

-(void)nadViewDidFailToReceiveAd:(NADView *)adView {
    //NSLog(@"delegate nadViewDidFailToLoad:");
}


- (void)configureView
{
    feedURL = [NSURL URLWithString:FEED_URL];
    
    //configuration
    //self.title = @"ニュースリーダー";
    
    //add refresh control to the table view
    if (autoRefresh) {
        refreshControl = [[UIRefreshControl alloc] init];
        
        [refreshControl addTarget:self
                           action:@selector(refreshInvoked:forState:)
                 forControlEvents:UIControlEventValueChanged];
        NSString* fetchMessage = [NSString stringWithFormat:@"Fetching: %@",feedURL];
        NSLog(@"%@\n",fetchMessage);
        refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:fetchMessage
                                                                         attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
        [self.rssTable addSubview: refreshControl];
    }

    [self refreshFeed];
    
    //add the header
    //self.rssTable.tableHeaderView = [[TableHeaderView alloc] initWithText:@"fetching feed"];
}

- (void)refreshFeed
{
    [DejalBezelActivityView activityViewForView:self.view];
    RSSLoader* rss = [[RSSLoader alloc] init];
    [rss fetchRssWithURL:feedURL
                complete:^(NSString *title, NSArray *results) {
                    
                    //completed fetching the RSS
                    dispatch_async(dispatch_get_main_queue(), ^{
                          _objects = results;
                        //_objects = [results sortedArrayUsingComparator:^(id firstObject, id secondObject) {
                        //    return [((NSString *)firstObject[1]) compare:((NSString *)secondObject[1]) options:NSNumericSearch];
                        //}];
                        NSInteger oldNumItems = numItem2Show;
                        [self updateNumItems];
                        if (numItem2Show!=oldNumItems) { // if more items to display
                            displayFeed = [NSMutableArray array];
                            for (NSInteger i = _objects.count-numItem2Show; i < _objects.count; i++) {
                                [displayFeed addObject:_objects[i]];
                            }
                            [self.rssTable reloadData];
                        }
                        // Stop refresh control
                        if (autoRefresh) [refreshControl endRefreshing];
                        [DejalBezelActivityView removeViewAnimated:YES];
                        if (_objects.count > numItem2Show) { // schedule new notification for tomorrow if more items available
                            [RSSViewController scheduleNotification4Tomorrow:1];
                        } else
                            // no more articles, so cancel notifications
                            [[UIApplication sharedApplication] cancelAllLocalNotifications];
                    });
                }];
}

- (void)updateNumItems
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    numItem2Show = [defaults integerForKey:NUMRSSSHOWN];
    NSDate *date = [defaults objectForKey:DATELASTITEM];
    NSDate *now = [NSDate date];
    if (date) {
        NSDateComponents *lastDate = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:now];
        NSLog(@"last date %@\n   today %@\n", lastDate, today);
        if ([today day] != [lastDate day] ||
            [today minute] != [lastDate minute] || [today hour] != [lastDate hour] ||   // for testing update every 1 minuite
            [today month] != [lastDate month] ||
            [today year] != [lastDate year]) {
            // today is new
            NSLog(@"Today is new,   object count %i\n", _objects.count);
            numItem2Show++;
            [defaults setObject:now forKey:DATELASTITEM];
        } else NSLog(@"Today is not recognized as new\n");
    } else {
        numItem2Show = 1;
        [defaults setObject:now forKey:DATELASTITEM];
    }
    if (numItem2Show > _objects.count) numItem2Show = _objects.count;
    NSLog(@"numItem2Show %i\n", numItem2Show);
    
    [defaults setInteger:numItem2Show forKey:NUMRSSSHOWN];
    [defaults synchronize];
}


- (void)refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}


- (IBAction)onClickClearNotification:(id)sender {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    [defaults setObject:now forKey:DATELASTITEM];
    [defaults setInteger:1 forKey:NUMRSSSHOWN];
    [defaults synchronize];
    [self onClickClose:self];
}

- (IBAction)onClickUpdate:(UIButton *)sender {
    [self refreshFeed];
}

- (IBAction)onClickClose:(id)sender
{
    //[self saveChanges];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return displayFeed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *newsCellIdentifier = @"NewsCell";
    
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:newsCellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsCellIdentifier];
    }
    RSSItem *object = displayFeed[indexPath.row];
    cell.titleText.text = object.title;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", object.date];
    
    return cell;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [_objects objectAtIndex:indexPath.row];
    CGRect cellMessageRect = [item.cellMessage boundingRectWithSize:CGSizeMake(200,10000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    return cellMessageRect.size.height;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    RSSItem *object = displayFeed[indexPath.row];
    [self showSite:object.link];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    infoView.delegate = nil;
    infoView = nil;
}

- (void)viewDidUnload {
    self.rssTable = nil;
    nadView_.delegate = nil;
    nadView_.rootViewController = nil;
    nadView_ = nil;
    infoView.delegate = nil;
    infoView = nil;
    [super viewDidUnload];
}
@end
