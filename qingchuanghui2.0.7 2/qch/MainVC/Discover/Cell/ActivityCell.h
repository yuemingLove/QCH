//
//  ActivityCell.h
//  qingchuanghui
//
//  Created by 青创汇 on 15/12/25.
//  Copyright © 2015年 SOLOLI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell{
    
    UIImageView *imageview;    //活动图片
    UILabel *titlelab;         //标题
    UILabel *locLab;           //城市
    UILabel *timelab;          //时间
    UILabel *informationlab;   //信息
    UILabel *numPreson;      //人数
    UILabel *statelab;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)updateData:(PActivityModel *)dict;

@end
