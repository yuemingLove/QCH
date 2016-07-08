//
//  ProjectLinkView.h
//  qch
//
//  Created by 青创汇 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProjectLinkView;
@protocol ProjectLinkViewDelegate <NSObject>

- (void)selectClicked:(UIButton *)sender index:(NSInteger)index;

@end

@interface ProjectLinkView : UICollectionReusableView
@property (nonatomic,strong)UIButton *nextbtn;
@property (nonatomic,weak) id<ProjectLinkViewDelegate>linkdelegate;
@property (nonatomic, copy)void(^button1Block)();// 更改按钮是否高亮
@property (nonatomic, copy)void(^button2Block)();// 更改按钮是否高亮
@property (nonatomic, copy)void(^button3Block)();// 更改按钮是否高亮

@end
