//
//  EnrollCell.h
//  qingchuanghui
//
//  Created by 青创汇 on 15/12/26.
//  Copyright © 2015年 SOLOLI. All rights reserved.
//
#import <UIKit/UIKit.h>
@class EnrollCell;

@protocol EnrollCellDelegate <NSObject>

-(void)selectImageView:(EnrollCell*)cell index:(NSInteger)index;

@end

@interface EnrollCell : UITableViewCell{
    UILabel *hengxianlab;
}
@property (nonatomic,strong) UILabel *EnrollTxt;
@property (nonatomic,strong) UILabel *EnrollNum;
@property (nonatomic,strong) UILabel *Enrolllab;
@property (nonatomic,strong) UIButton *MoreBtn;

@property (nonatomic,assign) id<EnrollCellDelegate> enrollDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)updateFrame:(NSMutableArray*)usePicArray;

@end
