//
//  CommitAlertView.h
//  qch
//
//  Created by 苏宾 on 16/3/12.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommitAlertViewDelegate <NSObject>
@optional

-(void)updateTextViewData:(NSString*)text;

@end

@interface CommitAlertView : UIView<UITextViewDelegate>
{
    UIView *bgView;
}
@property (nonatomic,retain) UITextView *textView;
@property (nonatomic,retain) UILabel *placeholder;
@property (nonatomic, copy) NSString *labelContnet;

@property (nonatomic,assign) id<CommitAlertViewDelegate>delegate;

-(id)initWithView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles  textViewPlaceholder:(NSString *)placeHolder;
-(id)initWithView:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
