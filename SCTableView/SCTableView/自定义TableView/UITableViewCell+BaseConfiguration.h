//
//  UITableViewCell+BaseConfiguration.h
//  AppFactory
//
//  Created by sobeycloud on 16/4/18.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCBaseTableCellInterFace <NSObject>

@required
//处理数据方法
- (void)dealWithData:(NSDictionary *)dict;
@optional
//返回cell高度方法。如果返回高度小于等于0或者不实现此方法，tableview将会按照自动布局方法计算行高。
- (CGFloat)getSubCellHeight;

@end

@interface UITableViewCell (BaseConfiguration)
@property(nonatomic, strong)UIColor *selectedColor;
@property(nonatomic, weak)UITableViewCell<SCBaseTableCellInterFace> *child;
@end
