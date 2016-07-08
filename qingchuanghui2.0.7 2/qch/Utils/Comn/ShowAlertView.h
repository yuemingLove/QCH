//
//  ShowAlertView.h
//  qingchuanghui
//
//  Created by 苏宾 on 15/12/16.
//  Copyright © 2015年 SOLOLI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowAlertViewDelegate <NSObject>
@optional

-(void)updateTextViewData:(NSString*)text;

@end

@interface ShowAlertView : UIView<UITextViewDelegate>

@property (nonatomic,retain) UITextView *textView;

@property (nonatomic,assign) id<ShowAlertViewDelegate>delegate;

-(id)initWithView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
