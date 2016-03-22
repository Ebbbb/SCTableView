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
// data delivery method
- (void)dealWithData:(NSDictionary *)dict;
//return cell height, if the the height is less than or equal to zero, we will return UITableViewAutomaticDimension in tableview's datasource method "heightForRowAtIndexPath".
- (CGFloat)getSubCellHeight;

@end

@interface SCBaseTableCell : UITableViewCell

@property(nonatomic, weak)id<SCBaseTableCellInterFace> child;
@property(nonatomic, strong)UIColor *selectedColor;

- (void)loadWithData:(NSDictionary *)dict;
- (CGFloat)getCellHeight;

@end
