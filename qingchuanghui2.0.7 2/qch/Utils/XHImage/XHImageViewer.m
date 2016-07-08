//
//  XHImageViewer.m
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHImageViewer.h"
#import "XHViewState.h"
#import "XHZoomingImageView.h"
// 图片保存成功提示文字
#define SDPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define SDPhotoBrowserSaveImageFailText @" >_< 保存失败 ";


@interface XHImageViewer ()<UIScrollViewDelegate>
{
    UIButton *_saveButton;
//    UIActivityIndicatorView *_indicatorView;
    UILabel *_indexLabel;

}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *imgViews;

@end

@implementation XHImageViewer

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.backgroundScale = 0.95;

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    pan.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)setImageViewsFromArray:(NSArray*)views {
    NSMutableArray *imgViews = [NSMutableArray array];
    for(id obj in views){
        if([obj isKindOfClass:[UIImageView class]]){
            [imgViews addObject:obj];
            
            UIImageView *view = obj;
            
            XHViewState *state = [XHViewState viewStateForView:view];
            [state setStateWithView:view];
            
            view.userInteractionEnabled = NO;
        }
    }
    _imgViews = [imgViews copy];
}

- (void)showWithImageViews:(NSArray*)views selectedView:(UIImageView*)selectedView {
    [self setImageViewsFromArray:views];
    
    if(_imgViews.count > 0){
        if(![selectedView isKindOfClass:[UIImageView class]] || ![_imgViews containsObject:selectedView]){
            selectedView = _imgViews[0];
        }
        [self showWithSelectedView:selectedView];
    }
}

#pragma mark- Properties

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[backgroundColor colorWithAlphaComponent:0]];
}

- (NSInteger)pageIndex {
    return (_scrollView.contentOffset.x / _scrollView.frame.size.width + 0.5);
}

#pragma mark- View management

- (UIImageView *)currentView {
    return [_imgViews objectAtIndex:self.pageIndex];
}

- (void)showWithSelectedView:(UIImageView*)selectedView {
    for(UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    const NSInteger currentPage = [_imgViews indexOfObject:selectedView];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if(_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
        _scrollView.alpha = 0;
        _scrollView.delegate=self;
    }
    
    [self addSubview:_scrollView];
    [window addSubview:self];
    
    const CGFloat fullW = window.frame.size.width;
    const CGFloat fullH = window.frame.size.height;
    
    selectedView.frame = [window convertRect:selectedView.frame fromView:selectedView.superview];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 1;
                         // 1. 序标
                         UILabel *indexLabel = [[UILabel alloc] init];
                         indexLabel.bounds = CGRectMake(0, 0, 80, 30);
                         indexLabel.textAlignment = NSTextAlignmentCenter;
                         indexLabel.textColor = [UIColor whiteColor];
                         indexLabel.hidden = YES;
                         indexLabel.font = [UIFont boldSystemFontOfSize:20];
                         indexLabel.backgroundColor = [UIColor clearColor];
                         indexLabel.layer.cornerRadius = indexLabel.bounds.size.height * 0.5;
                         indexLabel.clipsToBounds = YES;
                         if (self.imgViews.count > 1) {
                             indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",currentPage+1,(long)self.imgViews.count];
                         }
                         _indexLabel = indexLabel;
                         _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 35);
                         [window addSubview:indexLabel];
                         // 2.保存按钮
                         UIButton *saveButton = [[UIButton alloc] init];
                         [saveButton setImage:[UIImage imageNamed:@"xiazai_btn"] forState:UIControlStateNormal];
                         [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                         saveButton.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
                         saveButton.layer.cornerRadius = 5;
                         saveButton.clipsToBounds = YES;
                         _saveButton = saveButton;
                         _saveButton.hidden = YES;
                         [saveButton addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
                         [window addSubview:saveButton];
                         _saveButton.frame = CGRectMake(self.bounds.size.width-80, self.bounds.size.height - 70, 50, 50);
                         [window addSubview:selectedView];
                         window.rootViewController.view.transform = CGAffineTransformMakeScale(self.backgroundScale, self.backgroundScale);
                         selectedView.transform = CGAffineTransformIdentity;
                         
                         CGSize size = (selectedView.image) ? selectedView.image.size : selectedView.frame.size;
                         CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                         CGFloat W = ratio * size.width;
                         CGFloat H = ratio * size.height;
                         selectedView.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             indexLabel.hidden = NO;
                             _saveButton.hidden = NO;
                         });
                     }
                     completion:^(BOOL finished) {
                         _scrollView.contentSize = CGSizeMake(_imgViews.count * fullW, 0);
                         _scrollView.contentOffset = CGPointMake(currentPage * fullW, 0);
                         
                         UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView:)];
                         [_scrollView addGestureRecognizer:gesture];
                         
                         for(UIImageView *view in _imgViews){
                             view.transform = CGAffineTransformIdentity;
                             
                             CGSize size = (view.image) ? view.image.size : view.frame.size;
                             CGFloat ratio = MIN(fullW / size.width, fullH / size.height);
                             CGFloat W = ratio * size.width;
                             CGFloat H = ratio * size.height;
                             view.frame = CGRectMake((fullW-W)/2, (fullH-H)/2, W, H);
                             
                             XHZoomingImageView *tmp = [[XHZoomingImageView alloc] initWithFrame:CGRectMake([_imgViews indexOfObject:view] * fullW, 0, fullW, fullH)];
                             tmp.imageView = view;
                             [_scrollView addSubview:tmp];
                         }
                     }
     ];
}

- (void)saveImage:(UIButton *)sender
{
    UIImageView *currentImageView = [self currentView];
    UIImageWriteToSavedPhotosAlbum(currentImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [SVProgressHUD showSuccessWithStatus:@"已保存至相册" maskType:SVProgressHUDMaskTypeBlack];
}

- (void)prepareToDismiss {
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    UIImageView *currentView = [self currentView];
    if([self.delegate respondsToSelector:@selector(imageViewer:willDismissWithSelectedView:)]) {
        [self.delegate imageViewer:self willDismissWithSelectedView:currentView];
    }
    for(UIImageView *view in _imgViews) {
        if(view != currentView) {
            XHViewState *state = [XHViewState viewStateForView:view];
            view.transform = CGAffineTransformIdentity;
            view.frame = state.frame;
            view.transform = state.transform;
            [state.superview addSubview:view];
        }
    }
}

- (void)dismissWithAnimate {
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    UIView *currentView = [self currentView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    CGRect rct = currentView.frame;
    currentView.transform = CGAffineTransformIdentity;
    currentView.frame = [window convertRect:rct fromView:currentView.superview];
    [window addSubview:currentView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _scrollView.alpha = 0;
                         window.rootViewController.view.transform =  CGAffineTransformIdentity;
                         
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.frame = [window convertRect:state.frame fromView:state.superview];
                         currentView.transform = state.transform;
                         // 发送回到小图通知
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"backToSmall" object:nil];
                     }
                     completion:^(BOOL finished) {
                         XHViewState *state = [XHViewState viewStateForView:currentView];
                         currentView.transform = CGAffineTransformIdentity;
                         currentView.frame = state.frame;
                         currentView.transform = state.transform;
                         [state.superview addSubview:currentView];
                         
                         for(UIView *view in _imgViews){
                             XHViewState *_state = [XHViewState viewStateForView:view];
                             view.userInteractionEnabled = _state.userInteratctionEnabled;
                         }
                         
                         [self removeFromSuperview];
                     }
     ];
}

#pragma mark- Gesture events

- (void)tappedScrollView:(UITapGestureRecognizer*)sender
{

    [self prepareToDismiss];
    [self dismissWithAnimate];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imgViews.count];
}

- (void)didPan:(UIPanGestureRecognizer*)sender
{
    static UIImageView *currentView = nil;
    
    if(sender.state == UIGestureRecognizerStateBegan){
        currentView = [self currentView];
        
        UIView *targetView = currentView.superview;
        while(![targetView isKindOfClass:[XHZoomingImageView class]]){
            targetView = targetView.superview;
        }
        
        if(((XHZoomingImageView *)targetView).isViewing){
            currentView = nil;
        }
        else{
            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
            currentView.frame = [window convertRect:currentView.frame fromView:currentView.superview];
            [window addSubview:currentView];
            
            [self prepareToDismiss];
        }
    }
    
    if(currentView){
        if(sender.state == UIGestureRecognizerStateEnded){
            if(_scrollView.alpha>0.5){
                [self showWithSelectedView:currentView];
            }
            else{
                [self dismissWithAnimate];
            }
            currentView = nil;
        }
        else{
            CGPoint p = [sender translationInView:self];
            
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, p.y);
            transform = CGAffineTransformScale(transform, 1 - fabs(p.y)/1000, 1 - fabs(p.y)/1000);
            currentView.transform = transform;
            
            CGFloat r = 1-fabs(p.y)/200;
            _scrollView.alpha = MAX(0, MIN(1, r));
        }
    }
}

@end
