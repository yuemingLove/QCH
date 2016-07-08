//
//  TextShowCell.m
//  qch
//
//  Created by 苏宾 on 16/3/15.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "TextShowCell.h"

@interface TextShowCell (){

    UILabel *textTitle;
    UILabel *textContent;
    UIButton *moreTextBtn;
    UIView *line;
}

@end

@implementation TextShowCell

+ (CGFloat)cellDefaultHeight:(TextEntity *)entity{
    
    //默认cell高度
    return 85.0;
}

+ (CGFloat)cellMoreHeight:(TextEntity *)entity{
    
    //展开后得高度(计算出文本内容的高度+固定控件的高度)
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [entity.textContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20*SCREEN_WSCALE, MAXFLOAT) options:option attributes:attribute context:nil].size;
    return size.height + 50;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, 150*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
        textTitle.font=Font(14);
        textTitle.textColor=[UIColor grayColor];
        [self.contentView addSubview:textTitle];
        
        textContent=[[UILabel alloc]initWithFrame:CGRectMake(textTitle.left, textTitle.bottom+5, SCREEN_WIDTH-20*SCREEN_WSCALE, 35)];
        textContent.font=Font(13);
        textContent.numberOfLines = 0;
        textContent.textColor=[UIColor blackColor];
        [self.contentView addSubview:textContent];
        
        moreTextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        moreTextBtn.frame=CGRectMake(SCREEN_WIDTH-50*SCREEN_WSCALE, textTitle.top, 50*SCREEN_WSCALE, textTitle.height);
        moreTextBtn.titleLabel.font=Font(14);
        [moreTextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreTextBtn addTarget:self action:@selector(showMoreText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreTextBtn];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    textTitle.text = self.entity.textName;
    
    textContent.text = self.entity.textContent;
    ///计算文本高度
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [self.entity.textContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20*SCREEN_WSCALE, MAXFLOAT) options:option attributes:attribute context:nil].size;
    if (self.entity.isShowMoreText){
        [textContent setFrame:CGRectMake(textTitle.left, textTitle.bottom+5, SCREEN_WIDTH - 20*SCREEN_WSCALE, size.height)];
        [moreTextBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    else
    {
        Liu_DBG(@"%lf---------%lf", size.height, 20*SCREEN_WSCALE);
        if (size.height < 35) {
            moreTextBtn.hidden = YES;
        } else {
            moreTextBtn.hidden = NO;
        }
        [moreTextBtn setTitle:@"展开" forState:UIControlStateNormal];
        [textContent setFrame:CGRectMake(textTitle.left, textTitle.bottom+5, SCREEN_WIDTH - 20*SCREEN_WSCALE, 35)];
    }
    
}

- (void)showMoreText{
    //将当前对象的isShowMoreText属性设为相反值
    self.entity.isShowMoreText = !self.entity.isShowMoreText;
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self);
    }
}

/**
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textTitle=[[UILabel alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, 150*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
        textTitle.font=Font(14);
        textTitle.textColor=[UIColor grayColor];
        [self.contentView addSubview:textTitle];
        
        textContent=[[UILabel alloc]initWithFrame:CGRectMake(textTitle.left, textTitle.bottom+5, SCREEN_WIDTH-20*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
        textContent.font=Font(13);
        textContent.numberOfLines = 0;
        textContent.textColor=[UIColor blackColor];
        [self.contentView addSubview:textContent];
//        line = [[UIView alloc] initWithFrame:CGRectMake(0, textContent.bottom + 13*PMBHEIGHT, ScreenWidth, 5*PMBHEIGHT)];
//        line.backgroundColor = [UIColor themeGrayColor];
//        [self.contentView addSubview:line];
        moreTextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        moreTextBtn.frame=CGRectMake(SCREEN_WIDTH-50*SCREEN_WSCALE, textTitle.top, 50*SCREEN_WSCALE, textTitle.height);
        moreTextBtn.titleLabel.font=Font(14);
        [moreTextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [moreTextBtn addTarget:self action:@selector(showMoreText) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:moreTextBtn];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    textTitle.text = self.entity.textName;
    
    textContent.text = self.entity.textContent;
    ///计算文本高度
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    CGSize size = [self.entity.textContent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20*SCREEN_WSCALE, MAXFLOAT) options:option attributes:attribute context:nil].size;
    if (self.entity.isShowMoreText){
        [textContent setFrame:CGRectMake(textTitle.left, textTitle.bottom+5, SCREEN_WIDTH - 20*SCREEN_WSCALE, size.height)];
        //[line setFrame:CGRectMake(0, textContent.bottom + 3*PMBHEIGHT, ScreenWidth, 5*PMBHEIGHT)];
        [moreTextBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    else
    {
//        if (size.height < 20) {
//            moreTextBtn.hidden = YES;
//        } else {
//            moreTextBtn.hidden = NO;
//        }
        [moreTextBtn setTitle:@"展开" forState:UIControlStateNormal];
        [textContent setFrame:CGRectMake(textTitle.left, textTitle.bottom+5, SCREEN_WIDTH - 20*SCREEN_WSCALE, 20*SCREEN_WSCALE)];
        //[line setFrame:CGRectMake(0, textContent.bottom + 13*PMBHEIGHT, ScreenWidth, 5*PMBHEIGHT)];
    }
}

- (void)showMoreText{
    //将当前对象的isShowMoreText属性设为相反值
    self.entity.isShowMoreText = !self.entity.isShowMoreText;
    if (self.showMoreTextBlock){
        self.showMoreTextBlock(self);
    }
}
*/
@end
