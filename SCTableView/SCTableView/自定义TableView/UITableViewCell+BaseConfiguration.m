//
//  UITableViewCell+BaseConfiguration.m
//  AppFactory
//
//  Created by sobeycloud on 16/4/18.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "UITableViewCell+BaseConfiguration.h"
#import <objc/runtime.h>

static void *selectedColorKey = &selectedColorKey;
static void *childKey = &childKey;
static void *indexPathKey = &indexPathKey;
@implementation UITableViewCell (BaseConfiguration)

- (void)setChild:(UITableViewCell<SCBaseTableCellInterFace> *)child {
}

- (UITableViewCell<SCBaseTableCellInterFace> *)child {
    if ([self conformsToProtocol:@protocol(SCBaseTableCellInterFace)]) {
        return self;
    }
    return nil;
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    objc_setAssociatedObject(self, selectedColorKey, selectedColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.selectedBackgroundView.backgroundColor = selectedColor;
}

- (UIColor *)selectedColor {
    return objc_getAssociatedObject(self, selectedColorKey);
}
- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, indexPathKey, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath
{
     return objc_getAssociatedObject(self, indexPathKey);
}

@end
