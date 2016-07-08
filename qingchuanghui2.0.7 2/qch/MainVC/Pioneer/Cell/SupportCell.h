//
//  SupportCell.h
//  qch
//
//  Created by 苏宾 on 16/1/30.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SupportCell;

@protocol SupportCellDelegate <NSObject>

-(void)supportSelectMoreBtn:(SupportCell *)cell index:(NSInteger)index;

@end



@interface SupportCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{

    NSInteger index;
}

@property (nonatomic,assign) id<SupportCellDelegate> supportDelegate;

@property (nonatomic,strong) IBOutlet UICollectionView *collectionView;


@property (nonatomic,strong) NSMutableArray *headlist;



@end
