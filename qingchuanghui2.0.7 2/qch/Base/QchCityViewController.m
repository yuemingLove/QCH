//
//  QchCityViewController.m
//  qch
//
//  Created by 苏宾 on 16/3/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import "QchCityViewController.h"
#import "AddressPickerViewController.h"

@interface QchCityViewController ()<AddressPickerDelegate,AddressPickerDataSource>

@end

@implementation QchCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[NSString stringWithFormat:@"当前位置-%@",UserDefaultEntity.city]];
    
    [self createFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createFrame{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    AddressPickerViewController *addressPickerController = [[AddressPickerViewController alloc] initWithFrame:self.view.frame];
    addressPickerController.dataSource = self;
    addressPickerController.delegate = self;
    [self addChildViewController:addressPickerController];
    [self.view addSubview:addressPickerController.view];
}

#pragma mark - BAddressController Delegate
- (NSArray*)arrayOfHotCitiesInAddressPicker:(AddressPickerViewController *)addressPicker{
    
    return _citylist;
}


- (void)addressPicker:(AddressPickerViewController *)addressPicker didSelectedCity:(NSString *)city{
    
    if ([_cityDelegate respondsToSelector:@selector(selectCityData:)]) {
        [_cityDelegate selectCityData:city];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


@end
