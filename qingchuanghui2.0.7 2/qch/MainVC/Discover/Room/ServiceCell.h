//
//  ServiceCell.h
//  qch
//
//  Created by 青创汇 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,strong)HXTagsView *tagsView;

@property (nonatomic,strong)UILabel *titleLab;

- (void)updateData:(NSMutableArray *)array;

@end
