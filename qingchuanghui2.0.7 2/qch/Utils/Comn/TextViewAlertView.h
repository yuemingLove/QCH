//
//  TextViewAlertView.h
//  qch
//
//  Created by 苏宾 on 16/3/4.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewAlertView : UIAlertView<UITextViewDelegate>


@property (nonatomic,retain) UITextView *textView;

@end
