//
//  PlaceProjectVC.m
//  qch
//
//  Created by 青创汇 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PlaceProjectVC.h"
#import "PlaceCell.h"
#import "ProjectDetailVC.h"

@interface PlaceProjectVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic,strong) NSMutableArray *placelist;


@end

@implementation PlaceProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"孵化案例";
    
    if (_placelist != nil ) {
        _placelist = [[NSMutableArray alloc]init];
    }
    
    [self createFrame];
    [self getData];
}

-(void)createFrame{
    
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setItemSize:CGSizeMake(100, 123)];//设置cell的尺寸
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);//设置其边界
    
    //接下来就在创建collectionView的时候初始化，就很方便了（能直接带上layout）
    _myCollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flowLayout];
    
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    //添加到主页面上去
    [self.view addSubview:_myCollectionView];
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"PlaceCell" bundle:nil] forCellWithReuseIdentifier:@"PlaceCell"];
}

-(void)getData{
    
    [HttpRoomAction GetPlaceProject:_guid top:PAGESIZE Token:[MyAes aesSecretWith:@"placeGuid"] complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _placelist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _placelist=[[NSMutableArray alloc]init];
        }
        [_myCollectionView reloadData];
    }];
}

#pragma mark -UICollectionViewDataSource
//指定组的个数 ，一个大组！！不是一排，是N多排组成的一个大组(与下面区分)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_placelist count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCell" forIndexPath:indexPath];
    NSDictionary *dict = [_placelist objectAtIndex:indexPath.row];

    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Project_ConverPic"]];
    [cell.PlaceImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
    cell.NameLab.text = [dict objectForKey:@"t_Project_Name"];
    
    return cell;
    
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(102, 140);
}

//布局确定每个section内的Item距离section四周的间距 UIEdgeInsets
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}
//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_placelist objectAtIndex:indexPath.row];
    
    ProjectDetailVC *projectDetail=[[ProjectDetailVC alloc]init];
    projectDetail.guId=[dict objectForKey:@"Guid"];
    [self.navigationController pushViewController:projectDetail animated:YES];
}

@end
