//
//  CardItem.m
//  MoriTest
//
//  Created by jhirota on 2012/08/31.
//  Copyright (c) 2012年 Jon Hirota. All rights reserved.
//

#import "CardItem.h"
#define BACKIMG_NAME = @""

@implementation CardItem {
    UIImage *imageCache;
    UIImage *thumbnailImage;
}

@synthesize title;
@synthesize desc;
@synthesize imageName;
@synthesize thumbnailView;

- (id)initWithCardData:(NSString *)ts imageData:(NSString *)is descData:(NSString *)ds
{
    self = [super init];
    
    self.title = ts;
    self.desc = ds;
    self.imageName = is;
    NSLog(@"Card init: \n%@\n%@\n%@\n", ts, ds, is);
    return self;
}

- (void)setCardData:(NSString *)ts imageData:(NSString *)is descData:(NSString *)ds
{
    self.title = ts;
    self.desc = ds;
    self.imageName = is;
}

- (UIImage *)image
{
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:self.imageName ofType:@"jpg"]; //path to the image file
    if (!imageCache) {
        imageCache = [UIImage imageWithContentsOfFile:imagePath];
    }
    return imageCache;
}

- (UIImage *)thumbnail
{
    if (!thumbnailImage) {
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:self.imageName ofType:@"png"];
        thumbnailImage = [UIImage imageWithContentsOfFile:imagePath];
    }
    return thumbnailImage;
}



@end
