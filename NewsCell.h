//
//  NewsCell.h
//  Kossori
//
//  Created by jhirota on 2013/03/25.
//  Copyright (c) 2013年 apppub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cellBackground;


@end
