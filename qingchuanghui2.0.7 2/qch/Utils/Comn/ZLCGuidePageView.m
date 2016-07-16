//
//  ZLCGuidePageView.m
//  GuidePage_Test
//
//  Created by shining3d on 16/6/7.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import "ZLCGuidePageView.h"
#import "QCHWelcomeVC.h"
#import "QCHNavigationController.h"

#define Button_Name    @"开始体验"
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation ZLCGuidePageView

- (instancetype)initWithFrame:(CGRect)frame WithImages:(NSArray *)images
{
	self = [super initWithFrame:frame];
	if (self) {
		
		//设置引导视图的scrollview
		self.guidePageView = [[UIScrollView alloc]initWithFrame:frame];
		self.guidePageView.backgroundColor = [UIColor redColor];
		self.guidePageView.contentSize = CGSizeMake(SCREEN_WIDTH*images.count, SCREEN_HEIGHT);
		self.guidePageView.bounces = NO;
		self.guidePageView.pagingEnabled = YES;
		self.guidePageView.showsHorizontalScrollIndicator = NO;
		self.guidePageView.delegate = self;
		[self addSubview:_guidePageView];
		
		//设置引导页上的跳过按钮
		UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.8, SCREEN_WIDTH*0.1, 50, 25)];
		[btn setTitle:@"跳过" forState:UIControlStateNormal];
		[btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
		btn.backgroundColor = [UIColor grayColor];
		btn.layer.cornerRadius = 5;
		[btn addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
//		[self addSubview:btn];
		
    
		//添加在引导视图上的多张引导图片
		for (int i=0; i<images.count; i++) {
			UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
			imageView.image = images[i];
			[self.guidePageView addSubview:imageView];
			
			
			//设置在最后一张图片上显示进入体验按钮
			if (i == images.count-1) {
				imageView.userInteractionEnabled = YES;
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, ScreenWidth*0.3, 30*PMBWIDTH);
                btn.center = CGPointMake(ScreenWidth/2, SCREEN_HEIGHT*0.8);
				[btn setTitle:Button_Name forState:UIControlStateNormal];
				btn.titleLabel.font = Font(14);
				[btn setTitleColor:TSEColor(110, 151, 245) forState:UIControlStateNormal];
				btn.backgroundColor = TSEColor(250, 254, 255);
                btn.layer.cornerRadius = btn.height/2;
                btn.layer.masksToBounds = YES;
                btn.layer.borderWidth=1.0f;
                btn.layer.borderColor = TSEColor(110, 151, 245).CGColor;
				[btn addTarget:self action:@selector(btn_Click:) forControlEvents:UIControlEventTouchUpInside];
				[imageView addSubview:btn];
			}
			
		}

		//设置引导页上的页面控制器
		self.imagePageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*0.9, SCREEN_WIDTH, 50*PMBWIDTH)];
		self.imagePageControl.currentPage = 0;
		self.imagePageControl.numberOfPages = images.count;
		self.imagePageControl.pageIndicatorTintColor = [UIColor blackColor];
		self.imagePageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        //设置用户交互
        self.imagePageControl.userInteractionEnabled = NO;
		[self addSubview:self.imagePageControl];
		
	}
	return self;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
	int page = scrollview.contentOffset.x / scrollview.frame.size.width;
	[self.imagePageControl setCurrentPage:page];
}

- (void)btn_Click:(UIButton *)sender
{

    [self removeFromSuperview];
    if ([UserDefaultEntity.t_User_Complete isEqualToString:@"1"]) {
        [self mainViewController];
    } else if([UserDefaultEntity.t_User_Complete isEqualToString:@"0"]){
        [self presentInitViewController];
    }else if ([self isBlankString:UserDefaultEntity.t_User_Complete]){
        [self presentInitViewController];
    }
}


-(void)mainViewController{
    
    QCHMainController *main = [[QCHMainController alloc] init];
    //[main.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].keyWindow.rootViewController = main;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication].keyWindow setBackgroundColor:TSEColor(244, 244, 244)];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}


-(void)presentInitViewController{
    
    QCHWelcomeVC *welcomeVC=[[QCHWelcomeVC alloc]init];
    _rootNavigationController=[[QCHNavigationController alloc]initWithRootViewController:welcomeVC];
    [_rootNavigationController setNavigationBarHidden:YES];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:_rootNavigationController];
    
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

- (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end
