//
//  MyInfoCell.h
//  qch
//
//  Created by 苏宾 on 16/2/29.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyInfoCell;

@protocol MyInfoCellDelegate <NSObject>

-(void)clinkListView:(MyInfoCell*)cell index:(NSInteger)index;

-(void)clickBigImage:(MyInfoCell*)cell;

@end

@interface MyInfoCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UIImageView *pImageView;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UILabel *oneLabel;

@property (nonatomic,weak) IBOutlet UILabel *dyCountLabel;
@property (nonatomic,weak) IBOutlet UILabel *careLabel;
@property (nonatomic,weak) IBOutlet UILabel *fsLabel;

@property (nonatomic,weak) IBOutlet UIButton *fristBtn;
@property (nonatomic,weak) IBOutlet UIButton *secordBtn;

@property (nonatomic,assign) id<MyInfoCellDelegate>infoDelegate;

@end
