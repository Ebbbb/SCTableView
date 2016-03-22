//
//  SCTableView.h
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>
//tableView配置项。
#define DataSource @"DataSource"
#define SectionHeader @"SectionHeader"
#define SectionFooter @"SectionFooter"

typedef void(^SCTableViewCellResponseBlock)(NSDictionary *data,NSInteger section,NSInteger row);

typedef int(^SCTableViewCellChooseBlock)(NSDictionary *data);

@interface SCTableView : UITableView

@property(nonatomic, assign)BOOL hasMultiSection;


//初始化方法。
- (instancetype)initWithFrame:(CGRect)frame CellClassNames:(NSArray *)cellClassNames NeedDeselect:(BOOL)needDeselect SelectedColor:(UIColor *)selectedColor style:(UITableViewStyle)tableViewStyle;

//数据加载方法。
- (void)setInfoWihtDict:(NSDictionary *)dict;

//cell选择反馈方法。
- (void)setCellResponseBlock:(SCTableViewCellResponseBlock)cellResponseBlock;

//cell类型选择方法。
//请将此方法的执行，放在数据加载方法之前（在tableView初始化行高会用到此方法）。
- (void)setCellChooseBlock:(SCTableViewCellChooseBlock)cellChooseBlock;
@end
