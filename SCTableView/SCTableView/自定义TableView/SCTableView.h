//
//  SCTableView.h
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCell+BaseConfiguration.h"
//tableView配置项。
extern NSString * const SCTableViewDataSource;
extern NSString * const SCTableViewSectionHeader;
extern NSString * const SCTableViewSectionFooter;

typedef void(^SCTableViewCellResponseBlock)(NSDictionary *data,NSIndexPath *indexPath);
typedef NSString*(^SCTableViewCellChooseBlock)(NSDictionary *data, NSIndexPath *indexPath);
typedef void(^SCTableViewDidEditCallBackBlock)(NSArray *myDataSource);
@interface SCTableView : UITableView

@property(nonatomic, assign)BOOL hasMultiSection;

//初始化方法。
- (instancetype)initWithFrame:(CGRect)frame NeedDeselect:(BOOL)needDeselect SelectedColor:(UIColor *)selectedColor style:(UITableViewStyle)tableViewStyle;

//数据加载方法。
- (void)setInfoWihtDict:(NSDictionary *)dict;

//cell选择反馈方法。
- (void)setCellResponseBlock:(SCTableViewCellResponseBlock)cellResponseBlock;

//cell类型选择方法。
//请将此方法的执行，放在数据加载方法之前（在tableView初始化行高会用到此方法）。
- (void)setCellChooseBlock:(SCTableViewCellChooseBlock)cellChooseBlock;
//编辑数据反馈方法
- (void)setDidEditCallBackBlock:(SCTableViewDidEditCallBackBlock)editCallBack;
@end
