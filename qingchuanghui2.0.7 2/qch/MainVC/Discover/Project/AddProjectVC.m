//
//  AddProjectVC.m
//  qch
//
//  Created by 青创汇 on 16/4/28.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "AddProjectVC.h"
#import "PSelectTypeVC.h"
#import "AddProjectInfoVC.h"

@interface AddProjectVC ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,QchCityViewControllerDelegate,PSelectTypeVCDelegate>{
    UIScrollView *scrollView;
    UIView *headView;
    UIView *mainView;
    UITextField *projectTfd;
    UILabel *stageLab;
    UITextField *recountTfd;
    UILabel *cityLab;
    UILabel *territoryLab;
    UITextView *describeView;
    UILabel *plancelab;
    UITextView *StrengthView;
    UILabel *plancelab1;
    UILabel *plancrlab2;
    UITextView *userView;
    UIImageView *headImageView;
    NSString *photoStr;
    NSString *stage;
    NSString *territory;
    NSMutableDictionary *AddProjectdict;
}

@property (nonatomic,strong) UILabel *numberLabel;

@end

@implementation AddProjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布项目";
    [self createFrame];
    if (!AddProjectdict) {
        AddProjectdict = [[NSMutableDictionary alloc] init];
    }
    // back
    UIButton *customBut = [UIButton buttonWithType:UIButtonTypeSystem];
    customBut.frame = CGRectMake(0, 0, 36*PMBWIDTH, 35*PMBHEIGHT);
    [customBut setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    customBut.imageEdgeInsets = UIEdgeInsetsMake(0, -38*PMBWIDTH, 0, 0);
    [customBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customButItem=[[UIBarButtonItem alloc]initWithCustomView:customBut];
    self.navigationItem.leftBarButtonItem = customButItem;    
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
    
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-60*SCREEN_WSCALE)/2, 40*SCREEN_WSCALE, 60*SCREEN_WSCALE, 60*SCREEN_WSCALE)];
    headImageView.layer.cornerRadius = 60*SCREEN_WSCALE / 2;
    headImageView.layer.masksToBounds = YES;
    headImageView.image = [UIImage imageNamed:@"photoImage"];
    headImageView.userInteractionEnabled = YES;
    [headView addSubview:headImageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updatePhotoImage)];
    [headImageView addGestureRecognizer:tap];
    
    UILabel *photoLabel=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-200*SCREEN_WSCALE)/2, headImageView.bottom+15*PMBWIDTH, 200*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
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
    
    UILabel *activityName=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, 70*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"项目名称:"];
    [mainView addSubview:activityName];
    
    projectTfd=[self createTextFieldFrame:CGRectMake(activityName.right, activityName.top, SCREEN_WIDTH-90*SCREEN_WSCALE, activityName.height) font:Font(14) placeholder:@"请输入项目名称(20字以内)"];
    projectTfd.textColor = [UIColor blackColor];
    [mainView addSubview:projectTfd];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, activityName.bottom+10*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line1 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line1];
    
    UILabel *stageLabLabel=[self createLabelFrame:CGRectMake(activityName.left, line1.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"项目阶段:"];
    [mainView addSubview:stageLabLabel];
    
    stageLab=[[UILabel alloc]initWithFrame:CGRectMake(stageLabLabel.right+10*SCREEN_WSCALE, stageLabLabel.top, SCREEN_WIDTH-130*SCREEN_WSCALE, stageLabLabel.height)];
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
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(stageLabLabel.left, stageLabLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line2 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line2];
    
    
    
    UILabel *recountLabel=[self createLabelFrame:CGRectMake(10*SCREEN_WSCALE, line2.bottom+10*SCREEN_WSCALE, 70*SCREEN_WSCALE, 24*SCREEN_WSCALE) color:[UIColor lightGrayColor] font:Font(14) text:@"一句话简介"];
    [mainView addSubview:recountLabel];
    
    recountTfd=[self createTextFieldFrame:CGRectMake(recountLabel.right, recountLabel.top, SCREEN_WIDTH-90*SCREEN_WSCALE, recountLabel.height) font:Font(14) placeholder:@""];
    recountTfd.textColor = [UIColor blackColor];
    recountTfd.delegate=self;
    recountTfd.textAlignment = NSTextAlignmentRight;
    [mainView addSubview:recountTfd];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(recountLabel.left, recountLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line];
    
    UILabel *cityLabLabel=[self createLabelFrame:CGRectMake(activityName.left, recountLabel.bottom+10*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"所在城市:"];
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
    
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, cityLabLabel.bottom+8*PMBWIDTH, SCREEN_WIDTH-10*SCREEN_WSCALE, 1*PMBWIDTH)];
    [line3 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line3];
    
    UILabel *territoryLabLabel=[self createLabelFrame:CGRectMake(activityName.left, line3.bottom+7*PMBWIDTH, activityName.width, activityName.height) color:[UIColor lightGrayColor] font:Font(14) text:@"项目领域:"];
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
    
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(0, territoryLabLabel.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    [line4 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line4];
    
    UILabel *describelab = [[UILabel alloc]initWithFrame:CGRectMake(activityName.left, line4.bottom+7*PMBWIDTH, activityName.width, activityName.height)];
    describelab.textColor = [UIColor blackColor];
    describelab.font = Font(14);
    describelab.text = @"项目描述";
    [mainView addSubview:describelab];
    
    UIView *line5=[[UIView alloc]initWithFrame:CGRectMake(describelab.left, describelab.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 1*SCREEN_WSCALE)];
    [line5 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line5];
    
    
    describeView = [[UITextView alloc]initWithFrame:CGRectMake(5*PMBWIDTH, line5.bottom+5*PMBWIDTH, ScreenWidth-10*PMBWIDTH, 90*PMBWIDTH)];
    describeView.font = Font(14);
    describeView.textColor = [UIColor blackColor];
    describeView.delegate = self;
    [mainView addSubview:describeView];
    
    plancelab = [self createLabelFrame:CGRectMake(5*PMBWIDTH, 10*PMBWIDTH, describeView.width-10*PMBWIDTH, 26*PMBWIDTH) color:[UIColor lightGrayColor] font:Font(13) text:@"说说您的项目解决了什么痛点，让更多人对您的项目感兴趣"];
    plancelab.numberOfLines = 0;
    [describeView addSubview:plancelab];
    
    
    UIView *line6=[[UIView alloc]initWithFrame:CGRectMake(0, describeView.bottom+8*SCREEN_WSCALE, SCREEN_WIDTH, 5*SCREEN_WSCALE)];
    [line6 setBackgroundColor:[UIColor themeGrayColor]];
    [mainView addSubview:line6];
    
    
    UILabel *Strengthlab = [[UILabel alloc]initWithFrame:CGRectMake(activityName.left, line6.bottom+5*PMBWIDTH, activityName.width, activityName.height)];
    Strengthlab.text = @"项目优势";
    Strengthlab.textColor = [UIColor blackColor];
    Strengthlab.font = Font(14);
    [mainView addSubview:Strengthlab];
    
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(activityName.left, Strengthlab.bottom+8*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line7.backgroundColor = [UIColor themeGrayColor];
    [mainView addSubview:line7];
    
    StrengthView = [[UITextView alloc]initWithFrame:CGRectMake(describeView.left, line7.bottom+5*PMBWIDTH, ScreenWidth-10*PMBWIDTH, describeView.height)];
    StrengthView.font = Font(14);
    StrengthView.textColor = [UIColor blackColor];
    StrengthView.delegate = self;
    [mainView addSubview:StrengthView];
    
    plancelab1 = [self createLabelFrame:CGRectMake(5*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH-10*PMBWIDTH, plancelab.height) color:[UIColor lightGrayColor] font:Font(13) text:@"说说您的项目与同行相比优势及亮点，让更多人对您的项目感兴趣"];
    plancelab1.numberOfLines = 0;
    [StrengthView addSubview:plancelab1];
    
    
    UIView *line8 = [[UIView alloc]initWithFrame:CGRectMake(0, StrengthView.bottom+8*PMBWIDTH, ScreenWidth, 5*PMBWIDTH)];
    line8.backgroundColor = [UIColor themeGrayColor];
    [mainView addSubview:line8];
    
    
    UILabel *userlab = [[UILabel alloc]initWithFrame:CGRectMake(activityName.left, line8.bottom+5*PMBWIDTH, activityName.width, activityName.height)];
    userlab.text = @"目标用户";
    userlab.textColor = [UIColor blackColor];
    userlab.font = Font(14);
    [mainView addSubview:userlab];
    
    UIView *line9 = [[UIView alloc]initWithFrame:CGRectMake(activityName.left, userlab.bottom+5*PMBWIDTH, ScreenWidth, 1*PMBWIDTH)];
    line9.backgroundColor = [UIColor themeGrayColor];
    [mainView addSubview:line9];
    
    userView = [[UITextView alloc]initWithFrame:CGRectMake(activityName.left, line9.bottom+5*PMBWIDTH, ScreenWidth-10*PMBWIDTH, describeView.height)];
    userView.font = Font(14);
    userView.textColor = [UIColor blackColor];
    userView.delegate = self;
    [mainView addSubview:userView];
    
    plancrlab2 = [self createLabelFrame:CGRectMake(5*PMBWIDTH, 5*PMBWIDTH, ScreenWidth-10*PMBWIDTH, plancelab.height) color:[UIColor lightGrayColor] font:Font(13) text:@"说说市场规模及目标用户"];
    plancrlab2.numberOfLines = 0;
    [userView addSubview:plancrlab2];
    
    _numberLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100*SCREEN_WSCALE, userView.bottom+2*SCREEN_WSCALE, 85*SCREEN_WSCALE, 17*SCREEN_WSCALE)];
    _numberLabel.text=@"0/2500";
    _numberLabel.textColor=[UIColor lightGrayColor];
    _numberLabel.font=Font(14);
    _numberLabel.textAlignment=NSTextAlignmentRight;
    [mainView addSubview:_numberLabel];
    
    UIView *line10 = [[UIView alloc]initWithFrame:CGRectMake(0, _numberLabel.bottom+8*PMBWIDTH, ScreenWidth, 5*PMBWIDTH)];
    line10.backgroundColor = [UIColor themeGrayColor];
    [mainView addSubview:line10];
    
    
    UIButton *nextbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame = CGRectMake(0, 0, 180*PMBWIDTH, 30*PMBWIDTH);
    nextbtn.center = CGPointMake(ScreenWidth/2, line10.bottom+30*PMBWIDTH);
    [nextbtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextbtn.backgroundColor = TSEColor(161, 201, 240);
    nextbtn.titleLabel.font = Font(14);
    nextbtn.layer.cornerRadius = nextbtn.height/2;
    [nextbtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:nextbtn];
    
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 900*PMBWIDTH)];
}

-(void)citySelectTapped:(UIButton *)sender{
    QchCityViewController *qchSelectCity=[[QchCityViewController alloc]init];
    qchSelectCity.cityDelegate=self;
    qchSelectCity.citylist=_citylist;
    [self.navigationController pushViewController:qchSelectCity animated:YES];
}

-(void)selectCityData:(NSString *)city{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cityLab.text=city;
    });
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
    pSelectType.theme=@"项目阶段-选择";
    pSelectType.type=83;
    [self.navigationController pushViewController:pSelectType animated:YES];
}

-(void)updatePSelectType:(NSDictionary*)dict{
    NSInteger pId=[(NSNumber*)[dict objectForKey:@"t_fId"]integerValue];
    if (pId==82) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            territoryLab.text=[dict objectForKey:@"t_Style_Name"];
            territory=[dict objectForKey:@"Id"];
        });
    }else if (pId==83) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            stageLab.text=[dict objectForKey:@"t_Style_Name"];
            stage=[dict objectForKey:@"Id"];
        });
    }
    
}

- (void)next{
    [projectTfd resignFirstResponder];
    [recountTfd resignFirstResponder];
    [describeView resignFirstResponder];
    [StrengthView resignFirstResponder];
    [userView resignFirstResponder];
    if ([self isBlankString:photoStr]) {
        [SVProgressHUD showErrorWithStatus:@"请上传项目LOGO" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:projectTfd.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入项目名称" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (projectTfd.text.length>20) {
       [SVProgressHUD showErrorWithStatus:@"项目名称限制20字以内" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:stage]) {
        [SVProgressHUD showErrorWithStatus:@"请选择项目阶段" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:recountTfd.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入一句话介绍" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (recountTfd.text.length<10) {
        [SVProgressHUD showErrorWithStatus:@"一句话介绍不能低于10个字" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if (recountTfd.text.length>100) {
       [SVProgressHUD showErrorWithStatus:@"一句话介绍不能超过100字" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:cityLab.text]) {
       [SVProgressHUD showErrorWithStatus:@"请选择所在城市" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:territory]) {
      [SVProgressHUD showErrorWithStatus:@"请选择项目领域" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:describeView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入项目描述" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:StrengthView.text]) {
    
        [SVProgressHUD showErrorWithStatus:@"请输入项目优势" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    if ([self isBlankString:userView.text]) {
       [SVProgressHUD showErrorWithStatus:@"请输入目标用户" maskType:SVProgressHUDMaskTypeBlack];
        return;
    }
    
    [AddProjectdict setObject:photoStr forKey:@"coverPic"];
    [AddProjectdict setObject:projectTfd.text forKey:@"pName"];
    [AddProjectdict setObject:stage forKey:@"pPhase"];
    [AddProjectdict setObject:recountTfd.text forKey:@"pOneWord"];
    [AddProjectdict setObject:cityLab.text forKey:@"cityName"];
    [AddProjectdict setObject:territory forKey:@"pField"];
    [AddProjectdict setObject:describeView.text forKey:@"pInstruction"];
    [AddProjectdict setObject:StrengthView.text forKey:@"perfer"];
    [AddProjectdict setObject:userView.text forKey:@"client"];
    
    AddProjectInfoVC *addinfo = [[AddProjectInfoVC alloc]init];
    addinfo.addprojectdict = AddProjectdict;
    [self.navigationController pushViewController:addinfo animated:YES];
}

-(void)updatePhotoImage{
    [projectTfd resignFirstResponder];
    [recountTfd resignFirstResponder];
    [describeView resignFirstResponder];
    [StrengthView resignFirstResponder];
    [userView resignFirstResponder];
    
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if(image != nil){
            NSData *imageData = [self imageWithImage:image scaledToSize:CGSizeMake(300, 150)];
            NSString *imageStr = [CommonDes base64EncodedStringFrom:imageData];
            headImageView.hidden = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 photoStr=imageStr;
                [headImageView setImage:image];
            });
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


- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] >= 2500) {
        textView.text = [textView.text substringToIndex:2500];
        return;
    }//250-
    self.numberLabel.text = [NSString stringWithFormat:@"%d/2500",(int)([textView.text length])];

    if ([describeView.text length]>0) {
        plancelab.hidden=YES;
    }else{
        plancelab.hidden= NO;
    }
    if ([StrengthView.text length]>0) {
        plancelab1.hidden = YES;
    }else{
        plancelab1.hidden = NO;
    }
    if ([userView.text length]>0) {
        plancrlab2.hidden = YES;
    }else{
        plancrlab2.hidden = NO;
    }
}
#pragma mark - backAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
