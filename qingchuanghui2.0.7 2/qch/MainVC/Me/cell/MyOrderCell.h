//
//  MyOrderCell.h
//  qch
//
//  Created by W.兵 on 16/4/14.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyOrderCell;

@protocol MyOrderCellDelegate <NSObject>

-(void)updateFrameView:(MyOrderCell*)myOrder index:(NSInteger)index;

@end

@interface MyOrderCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *numberLabel;
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *priceLabel;
@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UILabel *orderName;

@property (nonatomic,weak) IBOutlet UIView *bgkView;

@property (nonatomic,assign) id<MyOrderCellDelegate> delegate;


-(void)updateDate:(NSDictionary*)dict;

@end
