//
//  SendProjectVC.m
//  qch
//
//  Created by 苏宾 on 16/2/18.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "SendProjectVC.h"
#import "PSelectTypeVC.h"

@interface SendProjectVC ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,QchCityViewControllerDelegate,PSelectTypeVCDelegate>{

    UIView *headView;
    UIImageView *headImageView;
    UIView *mainView;
    UIScrollView *scrollView;
    
    UIBarButtonItem *cancalBtn;
    
    UITextField *projectTfd;
    UITextField *recountTfd;
    UITextView *contentView;
    UILabel *planceLabel;
    
    UILabel *cityLab;
    UILabel *territoryLab;
    UILabel *stageLab;
    UILabel *rongziLab;
    
    NSString *territory;
    NSString *stage;
    NSString *rongzi;
    
    UITextField *scaleTfd;
    UITextField *useTfd;
    
    UILabel *colludeLabel;
    
    NSString *photoStr;
    
    NSString *waitStr;
}

@property (nonatomic,strong) NSMutableArray *partnerlist;

@property (nonatomic,strong) UILabel *numberLabel;

@property (nonatomic,strong) NSMutableArray *wantlist;

@end

@implementation SendProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"发布项目"];
    [self getHeHuoRenList];
    
    if (_partnerlist !=nil) {
        _partnerlist=[[NSMutableArray alloc]init];
    }
    
    if (_wantlist !=nil) {
        _wantlist=[[NSMutableArray alloc]init];
    }
    
    [self createFrame];
    
    cancalBtn=[[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(commitMsgBtn:)];
    cancalBtn.enabled=NO;
    self.navigationItem.rightBarButtonItem=cancalBtn;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createFrame{

    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [scrollView setBackgroundColor:[UIColor themeGrayColor]];
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:headView];
    
    UIButton *photoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame=CGRectMake((SCREEN_WIDTH-100*SCREEN_WSCALE)/2, 20*SCREEN_WSCALE, 100*SCREEN_WSCALE, 100*SCREEN_WSCALE);
    [photoBtn setImage:[UIImage imageNamed:@"photoImage"] forState:UIControlStateNormal];
    photoBtn.layer.masksToBounds=YES;
    photoBtn.layer.cornerRadius=photoBtn.height/2;
    [photoBtn addTarget:self action:@selector(updatePhotoImage:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:photoBtn];
    
    UILabel *photoLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200*SCREEN_WSCALE)/2, photoBtn.bottom+5, 200*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
    photoLabel.text=@"创建项目LOGO";
    photoLabel.textAlignment=NSTextAlignmentCenter;
    photoLabel.font=Font(14);
    photoLabel.textColor=[UIColor lightGrayColor];
    [headView addSubview:photoLabel];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, headView.height-5*SCREEN_WSCALE, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [headView addSubview:line];
    
    [self createMainView];
}

-(void)createMainView{

    mainView=[[UIView alloc]initWithFrame:CGRectMake(0, headView.bottom, SCREEN_WIDTH, 1000*SCREEN_WSCALE)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:mainView];
    
    UILabel *activityName=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, 70*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"项目名称:"];
    [mainView addSubview:activityName];
    
    projectTfd=[self createTextFieldFrame:CGRectMake(activityName.right, activityName.top, SCREEN_WIDTH-90*SCREEN_WSCALE, activityName.height) font:Font(14) placeholder:@"请输入项目名称"];
    [mainView addSubview:projectTfd];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, activityName.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line1 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line1];
    
    UILabel *recountLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line1.bottom+10*SCREEN_WSCALE, 70*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor blackColor] font:Font(14) text:@"项目简述:"];
    [mainView addSubview:recountLabel];
    
    recountTfd=[self createTextFieldFrame:CGRectMake(recountLabel.right, recountLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, recountLabel.height) font:Font(14) placeholder:@"(20字以内)"];
    recountTfd.delegate=self;
    [mainView addSubview:recountTfd];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, recountLabel.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line2 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line2];
    
    contentView=[[UITextView alloc]initWithFrame:CGRectMake(5*SCREEN_WSCALE, line2.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-10*SCREEN_WSCALE, 150*SCREEN_WSCALE) textContainer:NSTextAlignmentLeft];
    contentView.font=Font(14);
    contentView.textColor=[UIColor blackColor];
    contentView.delegate=self;
    [mainView addSubview:contentView];
    
    planceLabel=[self createLabelFrame:CGRectMake(5*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH, 16) color:[UIColor lightGrayColor] font:Font(13) text:@"填写项目简介，让更多人对您的项目感兴趣……"];
    [contentView addSubview:planceLabel];
    
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100*SCREEN_WSCALE, contentView.bottom+2*SCREEN_WSCALE, 85*SCREEN_WSCALE, 17*SCREEN_WSCALE)];
    _numberLabel.text=@"0/2500";
    _numberLabel.textColor=[UIColor lightGrayColor];
    _numberLabel.font=Font(14);
    _numberLabel.textAlignment=NSTextAlignmentRight;
    [mainView addSubview:_numberLabel];
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, _numberLabel.bottom+2*SCREEN_WSCALE, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    [line3 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line3];
    
    
    UILabel *cityLabLabel=[self createLabelFrame:CGRectMake(activityName.left, line3.bottom+10*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"所在城市:"];
    [mainView addSubview:cityLabLabel];
    
    cityLab=[[UILabel alloc]initWithFrame:CGRectMake(cityLabLabel.right+7*SCREEN_WSCALE, cityLabLabel.top, SCREEN_WIDTH-130*SCREEN_WSCALE, cityLabLabel.height)];
    cityLab.textAlignment=NSTextAlignmentRight;
    cityLab.textColor=[UIColor blackColor];
    cityLab.font=Font(14);
    [mainView addSubview:cityLab];
    
    UIButton *cityBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame=cityLab.frame;
    [cityBtn addTarget:self action:@selector(citySelectTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cityBtn];
    
    UIImageView *nextImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, cityLab.top+3*SCREEN_WSCALE, 15*SCREEN_WSCALE, 18*PMBWIDTH)];
    nextImgeView.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeView];
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, cityLabLabel.bottom+8*PMBWIDTH, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*PMBWIDTH)];
    [line4 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line4];
    
    UILabel *territoryLabLabel=[self createLabelFrame:CGRectMake(activityName.left, line4.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"项目领域:"];
    [mainView addSubview:territoryLabLabel];
    
    territoryLab=[[UILabel alloc]initWithFrame:CGRectMake(territoryLabLabel.right+10*SCREEN_WSCALE, territoryLabLabel.top, SCREEN_WIDTH-130*SCREEN_WSCALE, cityLabLabel.height)];
    territoryLab.textAlignment=NSTextAlignmentRight;
    territoryLab.textColor=[UIColor blackColor];
    territoryLab.font=Font(14);
    [mainView addSubview:territoryLab];
    
    UIButton *territoryLabBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    territoryLabBtn.frame=territoryLab.frame;
    [territoryLabBtn addTarget:self action:@selector(territoryTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:territoryLabBtn];
    
    UIImageView *nextImgeViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, territoryLab.top+3*SCREEN_WSCALE, 15*PMBWIDTH, 18*PMBWIDTH)];
    nextImgeViewTwo.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeViewTwo];
    
    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(territoryLabLabel.left, territoryLabLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line5 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line5];


    UILabel *stageLabLabel=[self createLabelFrame:CGRectMake(activityName.left, line5.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"项目阶段:"];
    [mainView addSubview:stageLabLabel];
    
    stageLab=[[UILabel alloc]initWithFrame:CGRectMake(stageLabLabel.right+10*SCREEN_WSCALE, stageLabLabel.top, SCREEN_WIDTH-130*SCREEN_WSCALE, cityLabLabel.height)];
    stageLab.textAlignment=NSTextAlignmentRight;
    stageLab.textColor=[UIColor blackColor];
    stageLab.font=Font(14);
    [mainView addSubview:stageLab];
    
    UIButton *stageLabBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    stageLabBtn.frame=stageLab.frame;
    [stageLabBtn addTarget:self action:@selector(stageTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:stageLabBtn];
    
    UIImageView *nextImgeViewThree = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, stageLab.top+3*SCREEN_WSCALE, 15*PMBWIDTH, 18*SCREEN_WSCALE)];
    nextImgeViewThree.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeViewThree];
    
    UIView *line6=[[UIView alloc]initWithFrame:CGRectMake(stageLabLabel.left, stageLabLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line6 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line6];
    
    UILabel *rongziLabLabel=[self createLabelFrame:CGRectMake(activityName.left, line6.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"融资阶段:"];
    [mainView addSubview:rongziLabLabel];
    
    rongziLab=[[UILabel alloc]initWithFrame:CGRectMake(rongziLabLabel.right+10*SCREEN_WSCALE, rongziLabLabel.top, SCREEN_WIDTH-130*SCREEN_WSCALE, cityLabLabel.height)];
    rongziLab.textAlignment=NSTextAlignmentRight;
    rongziLab.textColor=[UIColor blackColor];
    rongziLab.font=Font(14);
    [mainView addSubview:rongziLab];
    
    UIButton *rongziLabBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rongziLabBtn.frame=rongziLab.frame;
    [rongziLabBtn addTarget:self action:@selector(rongziTapped:) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:rongziLabBtn];
    
    UIImageView *nextImgeViewFour = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25*SCREEN_WSCALE, rongziLab.top+3*SCREEN_WSCALE, 15*PMBWIDTH, 18*SCREEN_WSCALE)];
    nextImgeViewFour.image = [UIImage imageNamed:@"select_next"];
    [mainView addSubview:nextImgeViewFour];

    UIView *line7=[[UIView alloc]initWithFrame:CGRectMake(0, rongziLabLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    [line7 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line7];
    
    UILabel *scaleTfdLabel=[self createLabelFrame:CGRectMake(activityName.left, line7.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"融资金额:"];
    [mainView addSubview:scaleTfdLabel];
    
    scaleTfd=[self createTextFieldFrame:CGRectMake(scaleTfdLabel.right, scaleTfdLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, activityName.height) font:Font(14) placeholder:@"融资50万/出让10%~15%股份"];
    scaleTfd.textColor=[UIColor blackColor];
    [mainView addSubview:scaleTfd];
    
    UIView *line8=[[UIView alloc]initWithFrame:CGRectMake(scaleTfdLabel.left, scaleTfdLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line8 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line8];
    
    UILabel *useTfdLabel=[self createLabelFrame:CGRectMake(activityName.left, line8.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"资金用途:"];
    [mainView addSubview:useTfdLabel];
    
    useTfd=[self createTextFieldFrame:CGRectMake(useTfdLabel.right, useTfdLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, activityName.height) font:Font(14) placeholder:@"研发费用50%；市场推广35%；管理15%"];
    useTfd.delegate=self;
    useTfd.textColor=[UIColor blackColor];
    [mainView addSubview:useTfd];

    UIView *line9=[[UIView alloc]initWithFrame:CGRectMake(0, useTfdLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    [line9 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line9];
    
    
    colludeLabel=[self createLabelFrame:CGRectMake(activityName.left, line9.bottom+5*SCREEN_WSCALE, SCREEN_WIDTH-20*SCREEN_WSCALE, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"合伙人需求(多选)"];
    [mainView addSubview:colludeLabel];
    
    [self createColludeView];
}

-(void)createColludeView{
    
    CGFloat width=(SCREEN_WIDTH-80*SCREEN_WSCALE)/3;
//    NSArray *array=@[@"技术",@"产品",@"设计",@"运营",@"营销",@"财税",@"法律",@"项目管理",@"商务谈判",@"推广策划"];
    for (int i=0; i<[_partnerlist count]; i++) {
        
        NSDictionary *dict=[_partnerlist objectAtIndex:i];
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(15*SCREEN_WSCALE+(i%3)*(width+20*SCREEN_WSCALE), colludeLabel.bottom+10*SCREEN_WSCALE+(i/3)*40*SCREEN_WSCALE, width, 30*SCREEN_WSCALE);
        [button setTitle:[dict objectForKey:@"t_Style_Name"] forState:UIControlStateNormal];
        button.titleLabel.font=Font(14);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=button.height/2;
        button.layer.borderColor=[UIColor blackColor].CGColor;
        button.layer.borderWidth=1;
        button.tag=i;
        [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:button];
    }

    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 700*SCREEN_WSCALE+40*SCREEN_WSCALE*([_partnerlist count]/3 +1))];
}

-(void)citySelectTapped:(UIButton *)sender{
    QchCityViewController *qchSelectCity=[[QchCityViewController alloc]init];
    qchSelectCity.cityDelegate=self;
    qchSelectCity.citylist=_citylist;
    [self.navigationController pushViewController:qchSelectCity animated:YES];
}

-(void)selectCityData:(NSString *)city{
    cityLab.text=city;
}

-(void)territoryTapped:(UIButton *)sender{
    PSelectTypeVC *pSelectType=[[PSelectTypeVC alloc]init];
    pSelectType.selectDelegate=self;
    pSelectType.theme=@"项目领域-选择";
    pSelectType.type=82;
    [self.navigationController pushViewController:pSelectType animated:YES];
}

-(void)stageTapped:(UIButton*)sender{
    PSelectTypeVC *pSelectType=[[PSelectTypeVC alloc]init];
    pSelectType.selectDelegate=self;
    pSelectType.theme=@"项目领域-选择";
    pSelectType.type=83;
    [self.navigationController pushViewController:pSelectType animated:YES];
}

-(void)rongziTapped:(UIButton*)sender{
    PSelectTypeVC *pSelectType=[[PSelectTypeVC alloc]init];
    pSelectType.selectDelegate=self;
    pSelectType.theme=@"融资阶段-选择";
    pSelectType.type=84;
    [self.navigationController pushViewController:pSelectType animated:YES];
}

-(void)selectType:(UIButton*)sender{
    UIButton *button=(UIButton*)sender;

    NSDictionary *dict=[_partnerlist objectAtIndex:button.tag];
    NSString *str=[dict objectForKey:@"Id"];
    if (button.isSelected) {
        [button setSelected:NO];
        button.backgroundColor=[UIColor whiteColor];
        button.layer.borderWidth=1;
        
        NSArray *array=[waitStr componentsSeparatedByString:@";"];
        NSString *wstr=nil;
        for (NSString *string in array) {
            if (![string isEqualToString:str]) {
                if ([self isBlankString:wstr]) {
                    wstr=string;
                } else {
                    wstr=[wstr stringByAppendingFormat:@";%@",string];
                }
            }
        }
        waitStr=wstr;
    }else{
        [button setSelected:YES];
        button.backgroundColor=[UIColor btnBgkGaryColor];
        button.layer.borderWidth=0;
        if ([self isBlankString:waitStr]) {
            waitStr=str;
        } else {
            waitStr=[waitStr stringByAppendingFormat:@";%@",str];
        }
    }
}

-(void)updatePSelectType:(NSDictionary*)dict{
    
    NSInteger pId=[(NSNumber*)[dict objectForKey:@"t_fId"]integerValue];
    if (pId==82) {
        territoryLab.text=[dict objectForKey:@"t_Style_Name"];
        territory=[dict objectForKey:@"Id"];
    }else if (pId==83) {
        stageLab.text=[dict objectForKey:@"t_Style_Name"];
        stage=[dict objectForKey:@"Id"];
    }else if (pId==84) {
        rongziLab.text=[dict objectForKey:@"t_Style_Name"];
        rongzi=[dict objectForKey:@"Id"];
    }
    
}

#pragma 合伙人需求
-(void)getHeHuoRenList{//85

    [HttpLoginAction getStyle:[MyAes aesSecretWith:@"Id"] Byid:85 complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            _partnerlist=(NSMutableArray*)[dict objectForKey:@"result"];
        }else{
            _partnerlist=[[NSMutableArray alloc]init];
        }
        [self createColludeView];
    }];
}


-(void)updatePhotoImage:(UIButton*)sender{

    [projectTfd resignFirstResponder];
    [recountTfd resignFirstResponder];
    [contentView resignFirstResponder];
    
    [cityLab resignFirstResponder];
    [territoryLab resignFirstResponder];
    [stageLab resignFirstResponder];
    [rongziLab resignFirstResponder];
    [planceLabel resignFirstResponder];
    
    [useTfd resignFirstResponder];
    [scaleTfd resignFirstResponder];
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(300, 150)];
            
            NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
            //    NSLog(@"图片路径：%@",imageStr);
            photoStr=imageStr;
            headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
            
            [headImageView setImage:image];
            [headView addSubview:headImageView];
            //        headView.userInteractionEnabled = NO;
            
            [headImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            headImageView.contentMode =  UIViewContentModeScaleAspectFill;
            headImageView.clipsToBounds  = YES;
        }
    }];
}

- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.6);
}

- (NSString*)encodeURL:(NSString *)string{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"),kCFStringEncodingUTF8));
    if (newString) {
        return newString;
    }
    return @"";
}


-(void)commitMsgBtn:(id)sender{
    
    if ([self isBlankString:photoStr]) {
        [Utils showToastWithText:@"请创建项目LOGO"];
        return;
    }
    if([self isBlankString:projectTfd.text]){
        [Utils showToastWithText:@"请输入项目名称"];
        return;
    }
    if([self isBlankString:recountTfd.text]){
        [Utils showToastWithText:@"请输入项目简述"];
        return;
    }
    if([self isBlankString:cityLab.text]){
        [Utils showToastWithText:@"请选择所在城市"];
        return;
    }
    if([self isBlankString:territory]){
        [Utils showToastWithText:@"请选择项目领域"];
        return;
    }
    if([self isBlankString:stage]){
        [Utils showToastWithText:@"请选择项目阶段"];
        return;
    }
    if([self isBlankString:rongzi]){
        [Utils showToastWithText:@"请选择融资阶段"];
        return;
    }
    if([self isBlankString:scaleTfd.text]){
        [Utils showToastWithText:@"请输入融资金额"];
        return;
    }
    if([self isBlankString:useTfd.text]){
        [Utils showToastWithText:@"请输入资金用途"];
        return;
    }

    if ([self isBlankString:waitStr]) {
        [Utils showToastWithText:@"请选择项目需求"];
        return;
    }
    
    NSMutableDictionary *request=[NSMutableDictionary new];
    [request setObject:UserDefaultEntity.uuid forKey:@"userGuid"];
    [request setObject:projectTfd.text forKey:@"pName"];
    [request setObject:recountTfd.text forKey:@"pOneWord"];
    [request setObject:contentView.text forKey:@"pInstruction"];
    [request setObject:cityLab.text forKey:@"cityName"];
    [request setObject:territory forKey:@"pField"];
    [request setObject:stage forKey:@"pPhase"];
    [request setObject:rongzi forKey:@"pFinancePhase"];
    [request setObject:scaleTfd.text forKey:@"pFinance"];
    [request setObject:useTfd.text forKey:@"pFinanceUse"];
    [request setObject:waitStr forKey:@"parterWant"];
    [request setObject:photoStr forKey:@"coverPic"];
    [request setObject:[MyAes aesSecretWith:@"userGuid"] forKey:@"Token"];

    [HttpProjectAction AddProject:request complete:^(id result, NSError *error) {
        
        NSDictionary *dict=result[0];
        [Utils showToastWithText:[dict objectForKey:@"result"]];
        if ([[dict objectForKey:@"state"] isEqualToString:@"true"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"refeleshView" forKey:@"refeleshView"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([[dict objectForKey:@"state"] isEqualToString:@"true"]){
            [Utils showToastWithText:[dict objectForKey:@"result"]];
        }else{
            [Utils showToastWithText:@"请检查信息重新提交"];
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] >= 2500) {
        textView.text = [textView.text substringToIndex:2500];
        return;
    }//250-
    self.numberLabel.text = [NSString stringWithFormat:@"%d/2500",(int)([textView.text length])];
    if ([textView.text length]>0) {
        planceLabel.hidden=YES;
    }else{
        planceLabel.hidden=NO;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([recountTfd.text length] >= 20) {
        [Utils showToastWithText:@"项目简述不能超过20字"];
        recountTfd.text = [recountTfd.text substringToIndex:20];
        return;
    }

    if (useTfd.text.length>0) {
        cancalBtn.enabled=YES;
    } else {
        cancalBtn.enabled=NO;
    }
}

@end
