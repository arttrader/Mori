//
//  CardItem.h
//  MoriTest
//
//  Created by jhirota on 2012/08/31.
//  Copyright (c) 2012年 Jon Hirota. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CardItem : NSObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * title;
@property UIImageView * thumbnailView;

- (id)initWithCardData:(NSString *)title imageData:(NSString *)is descData:(NSString *)ds;

- (void)setCardData:(NSString *)ts imageData:(NSString *)is descData:(NSString *)ds;

- (UIImage *)image;

- (UIImage *)thumbnail;
@end
