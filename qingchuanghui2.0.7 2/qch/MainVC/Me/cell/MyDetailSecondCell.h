//
//  MyDetailFirstCell.h
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDetailSecondCellDelegate <NSObject>

- (void)clickTheSecondButton:(NSInteger)tag;

@end

@interface MyDetailSecondCell : UITableViewCell

@property (nonatomic, weak)id<MyDetailSecondCellDelegate> delegate;

@end
