//
//  SupportCell.m
//  qch
//
//  Created by 苏宾 on 16/1/30.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SupportCell.h"
#import "HeaderCell.h"

@implementation SupportCell

- (void)awakeFromNib {
    [self setUpCollection];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setUpCollection{

    CGSize itemSize = CGSizeMake(36, 36);
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(38, 0, SCREEN_WIDTH-48, 44) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"HeaderCell" bundle:nil] forCellWithReuseIdentifier:@"header"];
    
    self.collectionView = collectionView;
    [self addSubview:self.collectionView];
    
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    index=(SCREEN_WIDTH-48)/48;
    if ([_headlist count]>index) {
        return index+1;
    } else {
        return [_headlist count]+1;
    }
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger count;
    if ([_headlist count]>index) {
        count=index;
    }else{
        count=[_headlist count];
    }
    
    if (indexPath.row==count) {
        HeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
        
        [cell.headImageView setImage:[UIImage imageNamed:@"hd_more_btn"]];
        
        [cell setNeedsLayout];
        
        return cell;

    } else {
        NSDictionary *dict=[_headlist objectAtIndex:indexPath.row];
        
        HeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"header" forIndexPath:indexPath];
        
        NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_USER,[dict objectForKey:@"PraiseUserPic"]];
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
        
        [cell setNeedsLayout];
        return cell;
    }
}



//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 1, 0, 0);

}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.supportDelegate respondsToSelector:@selector(supportSelectMoreBtn:index:)]) {
        [self.supportDelegate supportSelectMoreBtn:self index:indexPath.row];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


@end
