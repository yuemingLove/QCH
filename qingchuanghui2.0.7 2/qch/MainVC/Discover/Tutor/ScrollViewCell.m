//
//  ScrollViewCell.m
//  qch
//
//  Created by W.兵 on 16/4/20.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ScrollViewCell.h"

@implementation ScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    self.adsView = [[CycleScrollView alloc] initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH-20, 160*SCREEN_WSCALE) animationDuration:3];
    [_adsView setFetchContentViewAtIndex:^UIView *(NSInteger pageIndex){
        if (pageIndex < [_adsArray count]) {
            
            NSDictionary *model = [self.adsArray objectAtIndex:pageIndex];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH-20, 160*SCREEN_WSCALE)];
            NSString *url= [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[model objectForKey:@"t_Pic_Url"]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_3"]];
            imageView.userInteractionEnabled = YES;
            [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
            imageView.contentMode =  UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds  = YES;
            imageView.tag = pageIndex;
            return imageView;
        }
        return [[UIView alloc] initWithFrame:CGRectZero];
    }];
    [_adsView setTotalPagesCount:^NSInteger{
        return [_adsArray count];
    }];
    [_adsView setTapActionBlock:^(NSInteger pageIndex) {
        if (pageIndex < [_adsArray count]) {
            _imageviews = [[NSMutableArray alloc] init];
            for (int i = 0; i<_adsArray.count; i++) {
                NSDictionary *dict = [_adsArray objectAtIndex:i];
                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(10*SCREEN_WSCALE, 10*SCREEN_WSCALE, SCREEN_WIDTH-20, 160*SCREEN_WSCALE)];
                NSString *url= [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Pic_Url"]];
                [image sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loading_3"]];
                [image setContentScaleFactor:[[UIScreen mainScreen] scale]];
                image.contentMode =  UIViewContentModeScaleAspectFill;
                image.clipsToBounds  = YES;
                [_imageviews addObject:image];
                [self addSubview:image];
            }
            _selectedimg = [_imageviews objectAtIndex:pageIndex];
            if ([self.ScrDelegate respondsToSelector:@selector(tapImageWithObject:)]) {
                [self.ScrDelegate tapImageWithObject:self];
            }
        }
        
    }];
    [self.contentView addSubview:self.adsView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
