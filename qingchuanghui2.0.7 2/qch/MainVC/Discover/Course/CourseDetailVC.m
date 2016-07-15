//
//  CourseDetailVC.m
//  qch
//
//  Created by W.兵 on 16/4/7.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "CourseDetailVC.h"

@interface CourseDetailVC (){
    CGRect playerFrame;
}
@property (strong, nonatomic) ZFPlayerView *playerView;


@end

@implementation CourseDetailVC

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(20);
         }];
         */
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [UIColor blackColor];
        //if use Masonry,Please open this annotation
        /*
         [self.playerView mas_updateConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.view).offset(0);
         }];
         */
    }
}
- (void)dealloc
{
    Liu_DBG(@"%@释放了",self.class);
    [self.playerView cancelAutoFadeOutControlBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    playerFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        // 设置播放前的占位图（需要在设置视频URL之前设置）
        self.playerView.placeholderImageName = @"nolive.jpg";
        self.playerView = [[ZFPlayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth/2)];
        self.playerView.videoURL = [NSURL URLWithString:self.URLString];
        [self.view addSubview:_playerView];
        //self.playerView.controlView.backBtn.hidden = YES;
        self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.right.equalTo(self.view);
            // 注意此处，宽高比16：9优先级比1000低就行，在因为iPhone 4S宽高比不是16：9
            make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f).with.priority(750);
        }];
        [self.playerView autoPlayTheVideo];
        __weak typeof(self) weakSelf = self;
        self.playerView.goBackBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
