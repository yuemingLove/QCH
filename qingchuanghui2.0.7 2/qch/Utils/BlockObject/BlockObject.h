//
//  BlockObject.h
//  DataMall
//
//  Created by 张如进 on 14-7-2.
//  Copyright (c) 2014年 raiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ ClickBolck)(id clickView,int index);

@interface BlockObject : NSObject
@property (nonatomic,strong) id block;

- (id)initWithBlock:(id)block;
+ (BlockObject *)infoWithBlock:(id)block;

@end


@interface BlockAlertView : UIAlertView

+ (UIAlertView *)showAlertWithTitle:(NSString *)title message:(NSString *)message alertViewStyle:(UIAlertViewStyle)alertViewStyle block:(ClickBolck)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end


@interface BlockActionSheet : UIActionSheet

+ (BlockActionSheet *)showActionSheetWithTitle:(NSString *)title block:(ClickBolck)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION ;

@end



@interface BlockTimer : NSTimer

+ (BlockTimer *)timerWithTime:(float)time interval:(float)interval changed:(void(^)(float remain))changed complete:(void(^)())complete;

@end
