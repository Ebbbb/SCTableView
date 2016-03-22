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


//initialized method
- (instancetype)initWithFrame:(CGRect)frame CellClassNames:(NSArray *)cellClassNames NeedDeselect:(BOOL)needDeselect SelectedColor:(UIColor *)selectedColor style:(UITableViewStyle)tableViewStyle;

//load data meothd
- (void)setInfoWihtDict:(NSDictionary *)dict;

//cell select method
- (void)setCellResponseBlock:(SCTableViewCellResponseBlock)cellResponseBlock;

//cell class choose method
//please implement this method before you implement load data method.(thisi method will be used in 'heightForRowAtIndexPath' method)
- (void)setCellChooseBlock:(SCTableViewCellChooseBlock)cellChooseBlock;
@end
