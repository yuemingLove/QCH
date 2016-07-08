//
//  SearchFriendResultCell.h
//  qch
//
//  Created by 苏宾 on 16/1/13.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchFriendResultCell;

@protocol SearchFriendResultCellDeleagte <NSObject>

-(void)addFriend:(SearchFriendResultCell*)cell index:(NSInteger)index;

@end

@interface SearchFriendResultCell : UITableViewCell

@property (nonatomic,assign) id<SearchFriendResultCellDeleagte> friendDelegate;

@property (nonatomic,strong) UIImageView *ivAva;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UIButton *addBtn;

@end
