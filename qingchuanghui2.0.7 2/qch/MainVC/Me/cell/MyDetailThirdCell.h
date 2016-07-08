//
//  MyDetailFirstCell.h
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDetailThirdCellDelegate <NSObject>

- (void)clickTheThirdButton:(NSInteger)tag;

@end

@interface MyDetailThirdCell : UITableViewCell

@property (nonatomic, weak)id<MyDetailThirdCellDelegate> delegate;

@end
