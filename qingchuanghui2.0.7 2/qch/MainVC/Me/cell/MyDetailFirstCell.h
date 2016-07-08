//
//  MyDetailFirstCell.h
//  qch
//
//  Created by W.兵 on 16/6/3.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDetailFirstCellDelegate <NSObject>

- (void)clickTheFirstButton:(NSInteger)tag;

@end

@interface MyDetailFirstCell : UITableViewCell

@property (nonatomic, weak)id<MyDetailFirstCellDelegate> delegate;

@end
