//
//  ServiceCell.m
//  qch
//
//  Created by 青创汇 on 16/2/27.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "ServiceCell.h"
@implementation ServiceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}
- (void)_initView{
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, 80*PMBWIDTH, 14*PMBWIDTH)];
    _titleLab.font = Font(14);
    _titleLab.textColor = [UIColor blackColor];
    [self addSubview:_titleLab];
    
    _tagsView = [[HXTagsView alloc] initWithFrame:CGRectMake(0, _titleLab.frame.origin.y+_titleLab.frame.size.height, ScreenWidth, 0)];
    _tagsView.type=0;
    [self addSubview:_tagsView];
    

}

- (void)updateData:(NSMutableArray *)array{
    
    NSArray *arr=[NSArray new];
    NSMutableArray *item=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in array) {
        NSString *name=[dict objectForKey:@"ServiceName"];
        [item addObject:name];
    }
    arr=[item copy];
    [_tagsView setTagAry:arr delegate:self];
    
    CGRect frame = [self frame];
    frame.size.height = _tagsView.frame.size.height+25*PMBWIDTH;
    self.frame = frame;
}
@end
