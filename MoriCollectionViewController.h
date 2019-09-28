//
//  MoriCollectionViewController.h
//  Mori
//
//  Created by Jon Hirota on 2013/02/05.
//  Copyright (c) 2013年 JHirota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "TabLikeMenuViewController.h"

@interface MoriCollectionViewController : TabLikeMenuViewController // UICollectionViewController
{
    NSMutableArray *selectedCardis;
    NSInteger selectedItemIndex;
}

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;


@end
