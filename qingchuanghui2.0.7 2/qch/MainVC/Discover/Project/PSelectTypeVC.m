//
//  PSelectTypeVC.m
//  qch
//
//  Created by 苏宾 on 16/2/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "PSelectTypeVC.h"
#import "PositionCell.h"

@interface PSelectTypeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *selectlist;

@end

@implementation PSelectTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.theme];
    // Do any additional setup after loading the view.
    
    [self createFrame];
    [self getStyleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createFrame{
    
    //创建布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //接下来就在创建collectionView的时候初始化，就很方便了（能直接带上layout）
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) collectionViewLayout:flowLayout];
    _myCollectionView.backgroundColor = [UIColor clearColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
//    _myCollectionView.allowsMultipleSelection=YES;
    //    _myCollectionView.allowsSelection=NO;
    //添加到主页面上去
    [self.view addSubview:_myCollectionView];
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"PositionCell" bundle:nil] forCellWithReuseIdentifier:@"positionCell"];

}

-(void)getStyleView{
    
    [HttpLoginAction getStyle:[MyAes aesSecretWith:@"Id"] Byid:self.type complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _selectlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
        }else{
            _selectlist=[[NSMutableArray alloc]init];
        }
        [_myCollectionView reloadData];
    }];
}

#pragma mark -UICollectionViewDataSource
//指定组的个数 ，一个大组！！不是一排，是N多排组成的一个大组(与下面区分)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_selectlist count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_selectlist objectAtIndex:indexPath.row] ;
    
    PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
    cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
    cell.nameLabel.textColor=[UIColor blackColor];
    //    [cell setBackgroundColor:[UIColor themeTextColorWithAlpha:0.6]];
    cell.layer.cornerRadius = cell.height/2;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
}

//定义每个UICollectionViewCell 的大小*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80*SCREEN_WSCALE, 30*SCREEN_WSCALE);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(25, 15, 15, 15);//分别为上、左、下、右
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10*SCREEN_WSCALE;
}


//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [_selectlist objectAtIndex:indexPath.row];

    if ([self.selectDelegate respondsToSelector:@selector(updatePSelectType:)]) {
        [self.selectDelegate updatePSelectType:dict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}


@end
