//
//  ProjectTypeVC.m
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectTypeVC.h"
#import "PositionCell.h"
#import "ThemeReusableView.h"

@interface ProjectTypeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{

    NSString *pPhase;
    NSString *pFinancePhase;
    NSString *pParterWant;
    NSString *pField;
}

@property (nonatomic,strong) UICollectionView *myCollectionView;

@property (nonatomic,strong) NSMutableArray *funlist;

@property (nonatomic,strong) NSMutableArray *phaselist;
@property (nonatomic,strong) NSMutableArray *financePhaselist;
@property (nonatomic,strong) NSMutableArray *pareterWantlist;
@property (nonatomic,strong) NSMutableArray *fieldlist;

@end

@implementation ProjectTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"项目筛选"];
    
    if(_funlist !=nil){
        _funlist=[[NSMutableArray alloc]init];
    }
    if(_phaselist !=nil){
        _phaselist=[[NSMutableArray alloc]init];
    }
    if(_financePhaselist !=nil){
        _financePhaselist=[[NSMutableArray alloc]init];
    }
    if(_pareterWantlist !=nil){
        _pareterWantlist=[[NSMutableArray alloc]init];
    }
    if(_fieldlist !=nil){
        _fieldlist=[[NSMutableArray alloc]init];
    }
    
    pPhase=@"";
    pFinancePhase=@"";
    pParterWant=@"";
    pField=@"";
    
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
    
    //_myCollectionView头视图的注册   奇葩的地方来了，头视图也得注册
    [_myCollectionView registerNib:[UINib nibWithNibName:@"ThemeReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"themeReusable"];
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"PositionCell" bundle:nil] forCellWithReuseIdentifier:@"positionCell"];
    
    [self createFootView];
}

-(void)createFootView{
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame=CGRectMake(0, _myCollectionView.bottom, SCREEN_WIDTH, 50);
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundColor:[UIColor themeBlueThreeColor]];
    [selectBtn addTarget:self action:@selector(selectData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
}

-(void)selectData:(id)sender{
    
    [[NSUserDefaults standardUserDefaults] setObject:pPhase forKey:@"pPhase"];
    [[NSUserDefaults standardUserDefaults] setObject:pFinancePhase forKey:@"pFinancePhase"];
    [[NSUserDefaults standardUserDefaults] setObject:pParterWant forKey:@"pParterWant"];
    [[NSUserDefaults standardUserDefaults] setObject:pField forKey:@"pField"];
    [[NSUserDefaults standardUserDefaults] setObject:@"refeleshView" forKey:@"refeleshView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getStyleView{
    
    [HttpProjectAction getStyles:[MyAes aesSecretWith:@"Ids"] Byids:@"82,83,84,85" complete:^(id result, NSError *error) {
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _funlist=[NSMutableArray arrayWithArray:[dict objectForKey:@"result"]];
            for (NSDictionary *typeDict in _funlist) {
                NSInteger typeId=[(NSNumber*)[typeDict objectForKey:@"Id"]integerValue];
                if (typeId==82) {
                    _phaselist=[NSMutableArray arrayWithArray:[typeDict objectForKey:@"children"]];
                }else if (typeId==83){
                    _financePhaselist=[NSMutableArray arrayWithArray:[typeDict objectForKey:@"children"]];
                }else if (typeId==84){
                    _pareterWantlist=[NSMutableArray arrayWithArray:[typeDict objectForKey:@"children"]];
                }else if (typeId==85){
                    _fieldlist=[NSMutableArray arrayWithArray:[typeDict objectForKey:@"children"]];
                }
            }
        }else{
            _funlist=[[NSMutableArray alloc]init];
        }
        [_myCollectionView reloadData];
    }];
}

#pragma mark -UICollectionViewDataSource
//指定组的个数 ，一个大组！！不是一排，是N多排组成的一个大组(与下面区分)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_funlist count];
}

//指定单元格的个数 ，这个是一个组里面有多少单元格，e.g : 一个单元格就是一张图片
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return [_phaselist count];
            break;
        case 1:
            return [_financePhaselist count];
            break;
        case 2:
            return [_pareterWantlist count];
            break;
        case 3:
            return [_fieldlist count];
            break;
        default:
            break;
    }
    return 0;
//    NSArray *array=[[_funlist objectAtIndex:section] objectForKey:@"children"];
//    return [array count];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ThemeReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"themeReusable" forIndexPath:indexPath];
    
    NSDictionary *dict=[_funlist objectAtIndex:indexPath.section];
    header.titleLabel.text = [dict objectForKey:@"t_Style_Name"];
    return header;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSDictionary *dict = [[[_funlist objectAtIndex:indexPath.section] objectForKey:@"children"]objectAtIndex:indexPath.row] ;
    
    if (indexPath.section==0) {
        
        NSDictionary *dict=[_phaselist objectAtIndex:indexPath.row];
        
        PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
        
        cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
        
        cell.nameLabel.textColor=[UIColor blackColor];
        cell.layer.cornerRadius = cell.height/2;
        cell.layer.masksToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;

        
    }else if (indexPath.section==1){
        NSDictionary *dict=[_financePhaselist objectAtIndex:indexPath.row];
        
        PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
        
        cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
        
        cell.nameLabel.textColor=[UIColor blackColor];
        cell.layer.cornerRadius = cell.height/2;
        cell.layer.masksToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        

    }else if (indexPath.section==2){
        NSDictionary *dict=[_pareterWantlist objectAtIndex:indexPath.row];
        PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
        
        cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
        
        cell.nameLabel.textColor=[UIColor blackColor];
        cell.layer.cornerRadius = cell.height/2;
        cell.layer.masksToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    }else{// if (indexPath.section==3)
        NSDictionary *dict=[_fieldlist objectAtIndex:indexPath.row];
        PositionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"positionCell" forIndexPath:indexPath];
        
        cell.nameLabel.text=[dict objectForKey:@"t_Style_Name"];
        
        cell.nameLabel.textColor=[UIColor blackColor];
        cell.layer.cornerRadius = cell.height/2;
        cell.layer.masksToBounds = YES;
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
}

//定义每个UICollectionViewCell 的大小*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80*SCREEN_WSCALE, 30*SCREEN_WSCALE);
}

//定义每个Section 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 15, 15, 15);//分别为上、左、下、右
}

//返回头headerView的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = CGSizeMake(1000, 32);
    return size;
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10*SCREEN_WSCALE;
}


//选择了某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.layer.borderWidth = 0.0f;
//    cell.backgroundColor=[UIColor themeGrayColor];
    
    if (indexPath.section==0) {
        NSDictionary *dict=[_phaselist objectAtIndex:indexPath.row];
        pPhase=[dict objectForKey:@"Id"];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 0.0f;
        cell.backgroundColor=[UIColor btnBgkGaryColor];
    }else if (indexPath.section==1){
        NSDictionary *dict=[_financePhaselist objectAtIndex:indexPath.row];
        pFinancePhase=[dict objectForKey:@"Id"];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 0.0f;
        cell.backgroundColor=[UIColor btnBgkGaryColor];
    }else if (indexPath.section==2){
        NSDictionary *dict=[_pareterWantlist objectAtIndex:indexPath.row];
        pParterWant=[dict objectForKey:@"Id"];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 0.0f;
        cell.backgroundColor=[UIColor btnBgkGaryColor];
    }else if (indexPath.section==3){
        NSDictionary *dict=[_fieldlist objectAtIndex:indexPath.row];
        pField=[dict objectForKey:@"Id"];
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 0.0f;
        cell.backgroundColor=[UIColor btnBgkGaryColor];
    }

    /**
    NSDictionary *dict = [[[_funlist objectAtIndex:indexPath.section] objectForKey:@"children"]objectAtIndex:indexPath.row];
    NSLog(@"点击是第几类型：%ld",indexPath.section);
    
    if ([[dict objectForKey:@"t_fId"] isEqualToString:@"82"]) {
        pPhase=[dict objectForKey:@"Id"];
    }else if ([[dict objectForKey:@"t_fId"] isEqualToString:@"83"]){
        pFinancePhase=[dict objectForKey:@"Id"];
    }else if ([[dict objectForKey:@"t_fId"] isEqualToString:@"84"]){
        pParterWant=[dict objectForKey:@"Id"];
    }else if ([[dict objectForKey:@"t_fId"] isEqualToString:@"84"]){
        pField=[dict objectForKey:@"Id"];
    }**/
    
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
/**
    NSDictionary *dict = [[[_funlist objectAtIndex:indexPath.section] objectForKey:@"children"]objectAtIndex:indexPath.row];
   
    if ([[dict objectForKey:@"t_fId"] isEqualToString:@"82"]) {
        pPhase=@"";
    }else if ([[dict objectForKey:@"t_fId"] isEqualToString:@"83"]){
        pFinancePhase=@"";
    }else if ([[dict objectForKey:@"t_fId"] isEqualToString:@"84"]){
        pParterWant=@"";
    }else if ([[dict objectForKey:@"t_fId"] isEqualToString:@"84"]){
        pField=@"";
    }
    **/
    
    if (indexPath.section==0) {
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        pPhase=@"";
    }else if (indexPath.section==1){
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        pFinancePhase=@"";
    }else if (indexPath.section==2){
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        pParterWant=@"";
    }else if (indexPath.section==3){
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        pField=@"";
    }
    
}




@end
