//
//  InfoTableViewCell.h
//  Jpbbo
//
//  Created by jpbbo on 15/7/9.
//  Copyright (c) 2015年 河南金马电子商务股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InfoTableViewCell;

@protocol InfoTableViewCellDelegate <NSObject>

- (BOOL)userInfoEditCellShouldBeginEidting:(InfoTableViewCell *)cell;

- (void)userInfoEditCellDidEndEditing:(InfoTableViewCell *)cell;

@end

@interface InfoTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString *cellKey;
@property (nonatomic,weak) id<InfoTableViewCellDelegate> delegate;
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UITextField *contentTF;

@end
