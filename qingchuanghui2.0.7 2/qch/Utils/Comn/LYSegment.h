//
//  LYSegment.h
//  qch
//  二个button滑动
//  Created by 青创汇 on 16/3/2.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentDelegate <NSObject>

@optional
- (void)scrollToPage:(int)page;
@end

@interface LYSegment : UIView{
     id <SegmentDelegate> delegate;
}


@property (nonatomic, weak) id <SegmentDelegate> delegate;
@property(nonatomic, assign) CGFloat maxWidth;
@property (nonatomic,strong) NSMutableArray *namelist;

@property(nonatomic,strong) NSMutableArray *titleList;
@property(nonatomic,strong) NSMutableArray *buttonList;
@property(nonatomic,weak) CALayer *LGLayer;
@property(nonatomic,assign) CGFloat bannerNowX;


+ (instancetype)initWithTitleList:(NSMutableArray *)titleList;
- (id)initWithTitleList:(NSMutableArray*)titleList;
- (void)moveToOffsetX:(CGFloat)X;

@end
