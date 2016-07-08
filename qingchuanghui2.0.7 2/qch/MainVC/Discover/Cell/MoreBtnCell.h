//
//  MoreBtnCell.h
//  qch
//
//  Created by 苏宾 on 16/1/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreBtnCell;

@protocol MoreBtnCellDelegate <NSObject>

-(void)CommentList:(MoreBtnCell*)cell;

@end

@interface MoreBtnCell : UITableViewCell

@property (nonatomic,assign) id<MoreBtnCellDelegate> moreDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
