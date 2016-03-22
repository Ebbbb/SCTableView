//
//  SCImageTextCell.m
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCLeftImageTextCell.h"

@implementation SCLeftImageTextCell

- (void)dealWithData:(NSDictionary *)dict {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([dict objectForKey:@"title"] && [dict[@"title"] isKindOfClass:[NSString class]]) {
        self.Name.text = dict[@"title"];
    }
    if ([dict objectForKey:@"icon"] && [dict[@"icon"] isKindOfClass:[NSString class]]) {
        if (![dict[@"icon"] hasPrefix:@"http"]) {
            self.Icon.image = [UIImage imageNamed:dict[@"iconUrl"]];
        }
    }
}

- (CGFloat)getSubCellHeight {
    return 44;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
