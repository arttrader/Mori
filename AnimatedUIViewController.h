//
//  AnimatedUIViewController.h
//  Hypno
//
//  Created by jhirota on 2012/12/06.
//
//

#import <UIKit/UIKit.h>
//#import "GAI.h"

@interface AnimatedUIViewController : UIViewController
{
    float animAppearTime, animCurlTime, animHideTime;
}
@property NSInteger transitionType;
@property NSInteger screenPosition;
@property (nonatomic, assign) UIViewController *delegate;

- (void)showView;
- (void)hideView;

@end
