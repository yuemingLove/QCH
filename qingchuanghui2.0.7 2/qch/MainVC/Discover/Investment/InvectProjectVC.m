//
//  InvectProjectVC.m
//  qch
//
//  Created by 苏宾 on 16/3/16.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "InvectProjectVC.h"
#import "PlaceCell.h"
#import "ProjectDetailVC.h"


@interface InvectProjectVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *myCollectionView;

@end

@implementation InvectProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"孵化项目"];

    [self createFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark -UICollectionViewDataSource
//指定组的个数 ，一个大组！！不是一排，是N多排组成的一个大组(与下面区分)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_projectlist count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PlaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlaceCell" forIndexPath:indexPath];
    NSDictionary *dict = [_projectlist objectAtIndex:indexPath.row];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"CasePic"]];
    [cell.PlaceImg sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading_2"]];
    cell.NameLab.text = [dict objectForKey:@"CaseName"];
    
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
    
    NSDictionary *dict = [_projectlist objectAtIndex:indexPath.row];
    
    ProjectDetailVC *projectDetail=[[ProjectDetailVC alloc]init];
    projectDetail.guId=[dict objectForKey:@"CaseGuid"];
    [self.navigationController pushViewController:projectDetail animated:YES];
}


@end
