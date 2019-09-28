//
//  ExplanationController.h
//  Mori
//
//  Created by Jon Hirota on 2013/04/27.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import "AnimatedUIViewController.h"

@interface ExplanationController : AnimatedUIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)goBack:(id)sender;

@end
