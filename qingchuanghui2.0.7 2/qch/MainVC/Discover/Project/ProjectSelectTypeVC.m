//
//  ProjectSelectTypeVC.m
//  qch
//
//  Created by 苏宾 on 16/2/22.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ProjectSelectTypeVC.h"

@interface ProjectSelectTypeVC ()<UIScrollViewDelegate>{
    
    NSString *pPhase;
    NSString *pFinancePhase;
    NSString *pParterWant;
    NSString *pField;
    
    UIView *fristView;
    UIView *secordView;
    UIView *thridView;
    UIView *fourView;

    UILabel *fristLabel;
    UILabel *secordLabel;
    UILabel *thridLabel;
    UILabel *fourLabel;
    CGFloat width;
}


@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSMutableArray *phaselist;
@property (nonatomic,strong) NSMutableArray *financePhaselist;
@property (nonatomic,strong) NSMutableArray *pareterWantlist;
@property (nonatomic,strong) NSMutableArray *fieldlist;

@end

@implementation ProjectSelectTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"项目筛选"];
    
    [self createFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createFrame{

    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
    _scrollView.backgroundColor=[UIColor whiteColor];
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    UIButton *selectBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame=CGRectMake(0, _scrollView.bottom, SCREEN_WIDTH, 50);
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectBtn setBackgroundColor:[UIColor themeBlueThreeColor]];
    [selectBtn addTarget:self action:@selector(selectData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    
    [self createDataView];
}

-(void)createDataView{
//    CGFloat height=30*SCREEN_WSCALE;
    width=(SCREEN_WIDTH-60*SCREEN_WSCALE)/3;
    
    for (NSDictionary *typeDict in _typelist) {
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
    
    fristView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ([_phaselist count]/3 +1)*45+24*SCREEN_WSCALE)];
    [fristView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:fristView];
    
    fristLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"项目领域"];
    [fristView addSubview:fristLabel];
    
    for (int i=0; i<[_phaselist count]; i++) {
        
        NSDictionary *dict=[_phaselist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), fristLabel.bottom+10+(i/3)*45, width, 30);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectFristType:) forControlEvents:UIControlEventTouchUpInside];
        [fristView addSubview:button];
    }

    
//    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, fristView.bottom-1, SCREEN_WIDTH, 1)];
//    [line setBackgroundColor:[UIColor btnBgkGaryColor]];
//    [fristView addSubview:line];
    
    secordView=[[UIView alloc]initWithFrame:CGRectMake(0, fristView.bottom, SCREEN_WIDTH, ([_financePhaselist count]/3 +1)*45+24*SCREEN_WSCALE)];
    [secordView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:secordView];
    
    secordLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"项目阶段"];
    [secordView addSubview:secordLabel];
    
    for (int i=0; i<[_financePhaselist count]; i++) {
        
        NSDictionary *dict=[_financePhaselist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), secordLabel.bottom+10+(i/3)*45, width, 30);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectSecordType:) forControlEvents:UIControlEventTouchUpInside];
        [secordView addSubview:button];
    }

    
//    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, secordView.bottom-1, SCREEN_WIDTH, 1)];
//    [line2 setBackgroundColor:[UIColor blackColor]];
//    [secordView addSubview:line2];
    
    thridView=[[UIView alloc]initWithFrame:CGRectMake(0, secordView.bottom, SCREEN_WIDTH, ([_pareterWantlist count]/3 +1)*45+24*SCREEN_WSCALE)];
    [thridView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:thridView];
    
    thridLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"融资状况"];
    [thridView addSubview:thridLabel];
    
    for (int i=0; i<[_pareterWantlist count]; i++) {
        
        NSDictionary *dict=[_pareterWantlist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), thridLabel.bottom+10+(i/3)*45, width, 30);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectThridType:) forControlEvents:UIControlEventTouchUpInside];
        [thridView addSubview:button];
    }
    
//    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, thridView.bottom-1, SCREEN_WIDTH, 1)];
//    [line3 setBackgroundColor:[UIColor blackColor]];
//    [thridView addSubview:line3];
    
    fourView=[[UIView alloc]initWithFrame:CGRectMake(0, thridView.bottom, SCREEN_WIDTH, ([_fieldlist count]/3 +1)*45+24*SCREEN_WSCALE)];
    [fourView setBackgroundColor:[UIColor whiteColor]];
    [_scrollView addSubview:fourView];
    
    fourLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"合作需求"];
    [fourView addSubview:fourLabel];
    
    for (int i=0; i<[_fieldlist count]; i++) {
        
        NSDictionary *dict=[_fieldlist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), fourLabel.bottom+10+(i/3)*45, width, 30);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectFourType:) forControlEvents:UIControlEventTouchUpInside];
        [fourView addSubview:button];
    }

    
    [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, (fristView.height+secordView.height+thridView.height+fourView.height+30*SCREEN_WSCALE))];
}


-(void)selectFristType:(UIButton *)sender{

    UIButton *button=(UIButton*)sender;
    NSInteger index=button.tag;
    NSDictionary *dict=[_phaselist objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderColor=[UIColor blackColor].CGColor;

        pField=@"";
    }else{
        
        fristView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ([_phaselist count]/3 +1)*45+24*SCREEN_WSCALE)];
        [fristView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:fristView];
        
        fristLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"项目领域"];
        [fristView addSubview:fristLabel];
        
        for (int i=0; i<[_phaselist count]; i++) {
            
            NSDictionary *dict=[_phaselist objectAtIndex:i];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), fristLabel.bottom+10+(i/3)*45, width, 30);
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.backgroundColor=[UIColor whiteColor];
            button.tag=i;
            
            if (index==i) {
                [button setSelected:YES];
                button.backgroundColor=[UIColor btnBgkGaryColor];
                button.layer.borderColor=[UIColor whiteColor].CGColor;
            }
            [button addTarget:self action:@selector(selectFristType:) forControlEvents:UIControlEventTouchUpInside];
            [fristView addSubview:button];
        }
        pField=str;
    }
}

-(void)selectSecordType:(UIButton*)sender{

    UIButton *button=(UIButton*)sender;
    NSInteger index=button.tag;
    NSDictionary *dict=[_financePhaselist objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        
        pPhase=@"";
    }else{
        
        secordView=[[UIView alloc]initWithFrame:CGRectMake(0, fristView.bottom, SCREEN_WIDTH, ([_financePhaselist count]/3 +1)*45+24*SCREEN_WSCALE)];
        [secordView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:secordView];
        
        secordLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"项目阶段"];
        [secordView addSubview:secordLabel];
        
        for (int i=0; i<[_financePhaselist count]; i++) {
            
            NSDictionary *dict=[_financePhaselist objectAtIndex:i];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), secordLabel.bottom+10+(i/3)*45, width, 30);
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.backgroundColor=[UIColor whiteColor];
            button.tag=i;
            
            if (index==i) {
                [button setSelected:YES];
                button.backgroundColor=[UIColor btnBgkGaryColor];
                button.layer.borderColor=[UIColor whiteColor].CGColor;
            }
            [button addTarget:self action:@selector(selectSecordType:) forControlEvents:UIControlEventTouchUpInside];
            [secordView addSubview:button];
        }
        pPhase=str;
    }

}

-(void)selectThridType:(UIButton *)sender{

    UIButton *button=(UIButton*)sender;
    NSInteger index=button.tag;
    NSDictionary *dict=[_pareterWantlist objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        
        pFinancePhase=@"";
    }else{
        
        thridView=[[UIView alloc]initWithFrame:CGRectMake(0, secordView.bottom, SCREEN_WIDTH, ([_pareterWantlist count]/3 +1)*45+24*SCREEN_WSCALE)];
        [thridView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:thridView];
        
        thridLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"融资状况"];
        [thridView addSubview:thridLabel];
        
        for (int i=0; i<[_pareterWantlist count]; i++) {
            
            NSDictionary *dict=[_pareterWantlist objectAtIndex:i];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), thridLabel.bottom+10+(i/3)*45, width, 30);
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.backgroundColor=[UIColor whiteColor];
            button.tag=i;
            
            if (index==i) {
                [button setSelected:YES];
                button.backgroundColor=[UIColor btnBgkGaryColor];
                button.layer.borderColor=[UIColor whiteColor].CGColor;
            }
            [button addTarget:self action:@selector(selectThridType:) forControlEvents:UIControlEventTouchUpInside];
            [thridView addSubview:button];
        }

        pFinancePhase=str;
    }

}

-(void)selectFourType:(UIButton*)sender{

    UIButton *button=(UIButton*)sender;
    NSInteger index=button.tag;
    NSDictionary *dict=[_fieldlist objectAtIndex:index];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderColor=[UIColor blackColor].CGColor;
        
        pParterWant=@"";
    }else{
        
        fourView=[[UIView alloc]initWithFrame:CGRectMake(0, thridView.bottom, SCREEN_WIDTH, ([_fieldlist count]/3 +1)*45+24*SCREEN_WSCALE)];
        [fourView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:fourView];
        
        fourLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 0, SCREEN_WIDTH-20*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"合作需求"];
        [fourView addSubview:fourLabel];
        
        for (int i=0; i<[_fieldlist count]; i++) {
            
            NSDictionary *dict=[_fieldlist objectAtIndex:i];
            
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), fourLabel.bottom+10+(i/3)*45, width, 30);
            [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
            button.titleLabel.font=Font(14);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.masksToBounds=YES;
            button.layer.cornerRadius=button.height/2;
            button.layer.borderColor=[UIColor blackColor].CGColor;
            button.layer.borderWidth=1;
            button.backgroundColor=[UIColor whiteColor];
            button.tag=i;
            
            if (index==i) {
                [button setSelected:YES];
                button.backgroundColor=[UIColor btnBgkGaryColor];
                button.layer.borderColor=[UIColor whiteColor].CGColor;
            }
            [button addTarget:self action:@selector(selectFourType:) forControlEvents:UIControlEventTouchUpInside];
            [fourView addSubview:button];
        }
        pParterWant=str;
    }

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

@end
