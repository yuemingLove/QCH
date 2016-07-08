//
//  AddressPickerViewController.h
//  qch
//
//  Created by 苏宾 on 16/3/8.
//  Copyright © 2016年 qch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressPickerViewController;

@protocol AddressPickerDataSource <NSObject>

@required
- (NSArray*)arrayOfHotCitiesInAddressPicker:(AddressPickerViewController*)addressPicker;

@end

@protocol AddressPickerDelegate <NSObject>

-(void)addressPicker:(AddressPickerViewController*)addressPicker didSelectedCity:(NSString*)city;

- (void)beginSearch:(UISearchBar*)searchBar;

- (void)endSearch:(UISearchBar*)searchBar;

@end

@interface AddressPickerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//数据源代理协议
@property (nonatomic, weak) id<AddressPickerDataSource> dataSource;
//委托代理协议
@property (nonatomic, weak) id<AddressPickerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
