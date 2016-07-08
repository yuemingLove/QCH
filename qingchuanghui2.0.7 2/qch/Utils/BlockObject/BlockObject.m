//
//  BlockObject.m
//  DataMall
//
//  Created by 张如进 on 14-7-2.
//  Copyright (c) 2014年 raiyi. All rights reserved.
//

#import "BlockObject.h"

@implementation BlockObject
@synthesize block = _block;

- (id)initWithBlock:(id)block {
    self = [super init];
    if (self) {
        self.block = block;
    }
    return self;
}

- (void)setBlock:(id)block {
    _block = block;
}
+ (BlockObject *)infoWithBlock:(id)block {
    BlockObject *info = [[BlockObject alloc] initWithBlock:block];
    return info;
}

@end


@interface BlockAlertView()
@property (nonatomic,strong) ClickBolck block;
@end

@implementation BlockAlertView
@synthesize block = _block;

+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message alertViewStyle:(UIAlertViewStyle)alertViewStyle block:(ClickBolck)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    alertView.delegate = alertView;
    alertView.alertViewStyle = alertViewStyle;
    alertView.block = block;
    va_list args;
    va_start(args, otherButtonTitles);
    if(otherButtonTitles != nil) {
        for (NSString *buttonTitle = va_arg(args,NSString*); buttonTitle != nil; buttonTitle = va_arg(args,NSString*)) {
            [alertView addButtonWithTitle:buttonTitle];
        }
    }
    va_end(args);
    [alertView show];
    
    return alertView;
}

- (void)setBlock:(ClickBolck)block {
    _block = block;
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (textField.text.length == 0) {
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block != nil) {
        self.block(self,(int)buttonIndex);
    }
}

@end


@interface BlockActionSheet() <UIActionSheetDelegate>
@property (nonatomic,strong) ClickBolck block;
@end


@implementation BlockActionSheet
@synthesize block = _block;

+ (BlockActionSheet *)showActionSheetWithTitle:(NSString *)title block:(ClickBolck)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    BlockActionSheet *actionSheet = [[BlockActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    actionSheet.block = block;
    actionSheet.delegate = actionSheet;
    va_list args;
    va_start(args, otherButtonTitles);
    int index = 0;
    if(otherButtonTitles != nil) {
        for (NSString *buttonTitle = otherButtonTitles; buttonTitle != nil; buttonTitle = va_arg(args,NSString*)) {
            [actionSheet addButtonWithTitle:buttonTitle];
            index ++;
        }
    }
    if ([cancelButtonTitle length] > 0) {
        [actionSheet addButtonWithTitle:cancelButtonTitle];
        [actionSheet setCancelButtonIndex:index];
    }
    va_end(args);
    [actionSheet showInView:[[[UIApplication sharedApplication] windows] objectAtIndex:0]];
    return actionSheet;
}

- (void)setBlock:(ClickBolck)block {
    _block = block;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block != nil) {
        self.block(self,(int)buttonIndex);
    }
}

@end


@interface TimerInfo : NSObject
@property (nonatomic,strong) BlockObject *chagedBlock;
@property (nonatomic,strong) BlockObject *completeBlock;
@property (nonatomic) float interval;
@property (nonatomic) float time;
@property (nonatomic) float remain;
@property (nonatomic,strong) NSTimer *timer;

+ (TimerInfo *)timeInfoWithTime:(float)time interval:(float)interval changed:(void(^)(float remain))changed complete:(void(^)())complete;

@end

typedef void(^TimerChanged)(float remain);
@implementation TimerInfo
@synthesize chagedBlock;
@synthesize completeBlock;
@synthesize interval;
@synthesize time;
@synthesize remain;
@synthesize timer = _timer;

+ (TimerInfo *)timeInfoWithTime:(float)time interval:(float)interval changed:(void(^)(float remain))changed complete:(void(^)())complete {
    TimerInfo *info = [[TimerInfo alloc] init];
    info.chagedBlock = [BlockObject infoWithBlock:changed];
    info.completeBlock = [BlockObject infoWithBlock:complete];
    info.interval = interval;
    info.time = time;
    info.remain = time;
    return info;
}
- (void)counter:(NSTimer *)timer {
    self.remain -= interval;
    TimerChanged block = self.chagedBlock.block;
    if (block) {
        block(self.remain);
    }
    if (self.remain <= 0 && self.time != 0) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        ((void(^)())self.completeBlock.block)();
    }
}

@end


@implementation BlockTimer
//倒计时
+ (BlockTimer *)timerWithTime:(float)time interval:(float)interval changed:(void(^)(float remain))changed complete:(void(^)())complete {
    TimerInfo *timeInfo = [TimerInfo timeInfoWithTime:time interval:interval changed:changed complete:complete];
    BlockTimer *timer = (BlockTimer *)[NSTimer scheduledTimerWithTimeInterval:interval target:timeInfo selector:@selector(counter:) userInfo:timeInfo repeats:YES];
    return timer;
}

@end