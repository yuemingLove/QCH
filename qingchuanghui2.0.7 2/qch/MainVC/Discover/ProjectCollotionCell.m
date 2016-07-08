//
//  ProjectCollotionCell.m
//  qch
//
//  Created by 苏宾 on 16/2/25.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectCollotionCell.h"
#import "ImageCell.h"

@implementation ProjectCollotionCell

- (void)awakeFromNib {
    [self setUpCollection];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setUpCollection{
    

    CGSize itemSize = CGSizeMake(80, 80);
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = itemSize;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"Image"];
    self.collectionView = collectionView;
    [self addSubview:self.collectionView];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_funlist count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Image" forIndexPath:indexPath];
    NSDictionary *dict = [_funlist objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Project_ConverPic"]];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_1"]];
    cell.headImageView.layer.masksToBounds=YES;
    cell.headImageView.layer.cornerRadius=cell.headImageView.height/2;
    [cell setNeedsLayout];
    return cell;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
    
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.projectDelegate respondsToSelector:@selector(projectSelectBtn:index:)]) {
        [self.projectDelegate projectSelectBtn:self index:indexPath.row];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


@end
