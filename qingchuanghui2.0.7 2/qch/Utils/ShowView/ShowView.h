//
//  ShowView.h
//  Photo
//
//  Created by lanouhn on 16/3/11.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowView : UIView
@property (nonatomic, copy) void(^block)();
@property (weak, nonatomic) IBOutlet UIView *bgkView;

@end
