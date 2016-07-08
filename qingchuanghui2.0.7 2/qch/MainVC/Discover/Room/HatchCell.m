//
//  HatchCell.m
//  
//
//  Created by 青创汇 on 16/2/27.
//
//

#import "HatchCell.h"

@implementation HatchCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView{
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10*PMBWIDTH, 10*PMBWIDTH, 80*PMBWIDTH, 14*PMBWIDTH)];
    titleLab.font = Font(14);
    titleLab.text = @"孵化案例";
    titleLab.textColor = [UIColor blackColor];
    [self addSubview:titleLab];
}

- (void)updateData:(NSMutableArray *)array{
    
    
    CGFloat width=(SCREEN_WIDTH-100)/4;
    
    NSInteger count=[array count];
    
    if (count>7) {
        count=8;
    } else {
        count=count;
    }
    
    for (int i=0; i<count; i++) {
        NSDictionary *dict=[array objectAtIndex:i];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+(width+20)*(i % 4), 34*SCREEN_WSCALE+(width+33*SCREEN_WSCALE)*(i/4), width, width);
        
        if (i==7) {
            [button setImage:[UIImage imageNamed:@"more_project"] forState:UIControlStateNormal];
            
            [button addTarget:self action:@selector(moreBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if (_type==1) {
                NSString *path = [NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"CasePic"]];
                [button sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_1"]];
            }else{
                NSString *path=[NSString stringWithFormat:@"%@%@",SERIVE_IMAGE,[dict objectForKey:@"t_Project_ConverPic"]];
                [button sd_setImageWithURL:[NSURL URLWithString:path] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_1"]];
            }
            
            [button addTarget:self action:@selector(selectProjectBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        button.layer.cornerRadius = width/2;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        button.tag = i;
        [self addSubview:button];
        
        [button setContentScaleFactor:[[UIScreen mainScreen] scale]];
        button.contentMode =  UIViewContentModeScaleAspectFill;
        button.clipsToBounds  = YES;
        
        UILabel *Namelab = [[UILabel alloc]initWithFrame:CGRectMake(button.left, button.bottom+5*PMBWIDTH, button.width, 13*PMBWIDTH)];
        Namelab.textColor = [UIColor blackColor];
        Namelab.font=Font(12);
        Namelab.textAlignment=NSTextAlignmentCenter;
        if (i==7) {
            Namelab.text=@"更多";
        } else {
            if (_type==1) {
                Namelab.text = [dict objectForKey:@"CaseName"];
            }else{
                Namelab.text=[dict objectForKey:@"t_Project_Name"];
            }

        }
        [self addSubview:Namelab];
    }
}

-(void)moreBtn:(id)sender{

    if ([self.hatchDelegate respondsToSelector:@selector(moreProject:index:)]) {
        [self.hatchDelegate moreProject:self index:_type];
    }
}

-(void)selectProjectBtn:(UIButton*)sender{

    if ([self.hatchDelegate respondsToSelector:@selector(selectProject:index:)]) {
        [self.hatchDelegate selectProject:self index:[sender tag]];
    }
}

@end
