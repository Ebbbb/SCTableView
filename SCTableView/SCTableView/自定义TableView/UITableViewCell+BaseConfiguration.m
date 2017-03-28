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
@implementation UITableViewCell (BaseConfiguration)

#pragma mark - 拦截系统方法进行初始化设置
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //When swizzling a class method, use the following:
        //Class class = object_getClass((id)self);
        
        NSArray *originalArray = @[@"layoutSubviews"];
        NSArray *swizzledArray = @[@"sc_layoutSubviews"];
        for (int i = 0; i < originalArray.count; i++) {
            SEL originalSelector = NSSelectorFromString(originalArray[i]);
            SEL swizzledSelector = NSSelectorFromString(swizzledArray[i]);
            Method originalMethod = class_getInstanceMethod(class, originalSelector);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
            BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
            if (didAddMethod) {
                class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            }
            else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

- (void)sc_layoutSubviews {
    if (self.selectedColor) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = self.selectedColor;
    }
    [self sc_layoutSubviews];
}

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

@end
