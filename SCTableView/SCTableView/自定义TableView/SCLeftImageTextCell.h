//
//  SCImageTextCell.h
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCBaseTableCell.h"

@interface SCLeftImageTextCell : SCBaseTableCell<SCBaseTableCellInterFace>
@property (weak, nonatomic) IBOutlet UIImageView *Icon;
@property (weak, nonatomic) IBOutlet UILabel *Name;

@end
