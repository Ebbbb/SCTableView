//
//  SCBaseTableCell.h
//  AppFactory
//
//  Created by sobeycloud on 16/2/18.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCBaseTableCellInterFace <NSObject>

@required
//处理数据方法
- (void)dealWithData:(NSDictionary *)dict;
//返回cell高度方法。如果高度小于等于0，tableview将会按照自动布局方法计算行高。
- (CGFloat)getSubCellHeight;

@end

@interface SCBaseTableCell : UITableViewCell

@property(nonatomic, weak)id<SCBaseTableCellInterFace> child;
@property(nonatomic, strong)UIColor *selectedColor;

- (void)loadWithData:(NSDictionary *)dict;
- (CGFloat)getCellHeight;
@end
