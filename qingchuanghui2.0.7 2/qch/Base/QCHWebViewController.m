//
//  QCHWebViewController.m
//  qch
//
//  Created by 苏宾 on 16/1/11.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QCHWebViewController.h"

@interface QCHWebViewController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIWebView *htmlWebView;

@property (nonatomic, weak) UIButton * backItem;
@property (nonatomic, weak) UIButton * closeItem;
@property (nonatomic, weak) UIActivityIndicatorView * activityView;

@end

@implementation QCHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.theme];
    
    self.navigationController.navigationBarHidden=NO;
    
    self.htmlWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.htmlWebView.delegate = self;
    self.htmlWebView.scrollView.decelerationRate = 1.f;
    [self.view addSubview:self.htmlWebView];
    
    if(self.type==1){
        NSArray *array=[self.url componentsSeparatedByString:@"."];
        [self.htmlWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:array[0] ofType:array[1]]]]];
    }else{
        [self initNaviBar];
        if ([_sharebtn isEqualToString:@"1"]) {
            UIBarButtonItem *shareView=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"fenxiang_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
            self.navigationItem.rightBarButtonItem=shareView;
        }
        NSURL *url = [NSURL URLWithString:self.url];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.htmlWebView loadRequest:request];

    }
}

- (void)initNaviBar{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [backItem setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backItem setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backItem setTitle:@"返回" forState:UIControlStateNormal];
    [backItem setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backItem setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    [backView addSubview:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(44+12, 0, 44, 44)];
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.hidden = YES;
    self.closeItem = closeItem;
    [backView addSubview:closeItem];
    
    UIBarButtonItem * leftItemBar = [[UIBarButtonItem alloc]initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftItemBar;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.htmlWebView.canGoBack) {
        [self.htmlWebView goBack];
        self.closeItem.hidden = NO;
        return NO;
    }
    return YES;
}

#pragma mark - clickedBackItem
- (void)clickedBackItem:(UIBarButtonItem *)btn{
    if (self.htmlWebView.canGoBack) {
        [self.htmlWebView goBack];
        self.closeItem.hidden = NO;
    }else{
        [self clickedCloseItem:nil];
    }
}

#pragma mark - clickedCloseItem
- (void)clickedCloseItem:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityView.hidden = NO;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    NSLog(@"url: %@", request.URL.absoluteURL.description);
    
    if (self.htmlWebView.canGoBack) {
        self.closeItem.hidden = NO;
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activityView.hidden = YES;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.activityView.hidden = YES;
}

- (void)share:(UIButton *)sender{
    
    //启动键盘
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //启用/禁用键盘
    manager.enable = NO;
    //启用/禁用键盘触摸外面
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    NSString *imageUrl =[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,_model.t_News_Pic];
    UIImageView *img = [[UIImageView alloc] init];
    
    [img sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"logo"]];
    NSString *path=[NSString stringWithFormat:@"%@NewsView.html?Guid=%@",SHARE_HTML,_model.Guid];
    //1、创建分享参数
    
    NSArray *imageArray = @[img.image];
        
        if (imageArray) {
            NSString *text = @"";
            if ([self isBlankString:_model.t_News_LimitContents]) {
                text = @"青创汇—新闻资讯";
            }else{
                text = _model.t_News_LimitContents;
            }
            if (_model.t_News_LimitContents.length>140) {
                text = [NSString stringWithFormat:@"%@",[_model.t_News_LimitContents substringToIndex:140]];
            }
            NSString *title = [[NSString stringWithFormat:@"%@",_model.t_News_Title] stringByReplacingOccurrencesOfString:@"==="withString:@"\n"];
            if (title.length>50) {
                title = [NSString stringWithFormat:@"%@",[title substringToIndex:50]];
            }
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            [shareParams SSDKSetupShareParamsByText:text
                                             images:imageArray
                                                url:[NSURL URLWithString:path]
                                              title:title
                                               type:SSDKContentTypeAuto];
            
            //2、分享（可以弹出我们的分享菜单和编辑界面）
            //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
            [ShareSDK showShareActionSheet:nil
                                     items:nil
                               shareParams:shareParams
                       onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                               //启动键盘
                               IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
                               //启用/禁用键盘
                               manager.enable = YES;
                               //启用/禁用键盘触摸外面
                               manager.shouldResignOnTouchOutside = YES;
                               manager.shouldToolbarUsesTextFieldTintColor = YES;
                               manager.enableAutoToolbar = NO;
                           switch (state) {

                               case SSDKResponseStateSuccess:
                               {
                                   [self ShareIntegral:@"9"];
                                   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                       message:nil
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"确定"
                                                                             otherButtonTitles:nil];
                                   [alertView show];
                                   break;
                               }
                               case SSDKResponseStateFail:
                               {
                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                   message:[NSString stringWithFormat:@"%@",error]
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil, nil];
                                   [alert show];
                                   break;
                               }
                               default:
                                   break;
                           }
                       }
             ];
        }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    //判断是否是单击
//    if (navigationType == UIWebViewNavigationTypeLinkClicked && self.clickBlock)
//    {
//        self.clickBlock();
//        return NO;
//    }
//    return YES;
//}
@end
