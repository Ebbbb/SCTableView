//
//  SCBaseTableCell.m
//  AppFactory
//
//  Created by sobeycloud on 16/2/18.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCBaseTableCell.h"

@implementation SCBaseTableCell

- (void)loadWithData:(NSDictionary *)dict {
    [self.child dealWithData:dict];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        if ([self conformsToProtocol:@protocol(SCBaseTableCellInterFace)]) {
            self.child = self;
        }
    }
    return self;
}

- (CGFloat)getCellHeight {
    if ([self.child respondsToSelector:@selector(getSubCellHeight)]) {
        return [self.child getSubCellHeight];
    }
    else {
        return 0;
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    self.selectedBackgroundView.backgroundColor = selectedColor;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
