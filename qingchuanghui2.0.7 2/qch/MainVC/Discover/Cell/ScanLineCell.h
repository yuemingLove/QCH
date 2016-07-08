//
//  ScanLineCell.h
//  qch
//
//  Created by W.兵 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ScanLineCell;

@protocol ScanLineCellDelegate <NSObject>

-(void)openScanLine:(ScanLineCell*)cell index:(NSInteger)index;

@end

@interface ScanLineCell : UITableViewCell

@property (nonatomic,assign) id<ScanLineCellDelegate> scanDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *wangzhi_btn0;
@property (weak, nonatomic) IBOutlet UIImageView *wangzhi_btn1;
@property (weak, nonatomic) IBOutlet UIImageView *wangzhi_btn2;


@end
