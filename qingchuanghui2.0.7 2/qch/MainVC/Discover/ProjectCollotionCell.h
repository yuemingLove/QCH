//
//  ProjectCollotionCell.h
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectCollotionCell;

@protocol ProjectCollotionCellDelegate <NSObject>

-(void)projectSelectBtn:(ProjectCollotionCell*)cell index:(NSInteger)index;

@end

@interface ProjectCollotionCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *funlist;

@property (nonatomic,assign) id<ProjectCollotionCellDelegate> projectDelegate;

@end
