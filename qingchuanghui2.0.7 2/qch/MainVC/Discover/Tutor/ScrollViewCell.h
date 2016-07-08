//
//  ScrollViewCell.h
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScrollViewCell;

@protocol ScrollViewCellDeleagte <NSObject>

- (void)tapImageWithObject:(ScrollViewCell *)cell;

@end

@interface ScrollViewCell : UITableViewCell

@property (nonatomic,strong) CycleScrollView *adsView;

@property (nonatomic,strong) NSArray *adsArray;

@property (nonatomic,weak) id<ScrollViewCellDeleagte> ScrDelegate;

@property (nonatomic,strong)NSMutableArray *imageviews;

@property (nonatomic,strong)UIImageView *selectedimg;

@end
