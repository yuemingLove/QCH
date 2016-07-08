//
//  SongVerticalScrollView.h
//  ZHCloudBusiness
//
//  Created by ewit song on 14-5-27.
//  Copyright (c) 2014年 song song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"
@interface SongVerticalScrollView : UIView<UIScrollViewDelegate>
@property (nonatomic , retain) UIScrollView *scrollView;
@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^verticalTotalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^verticalFetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^verticalTapActionBlock)(NSInteger pageIndex);


@end
