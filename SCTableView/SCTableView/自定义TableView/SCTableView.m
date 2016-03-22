//
//  SCTableView.m
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCTableView.h"
#import "SCBaseTableCell.h"

@interface SCTableView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSArray *cellIdentifiers;
@property(nonatomic, strong)NSMutableArray *tempCells;
@property(nonatomic, assign)BOOL needDeselect;
@property(nonatomic, strong)UIColor *selectedColor;
@property(nonatomic, strong)NSArray *myDataSource;
@property(nonatomic, strong)NSArray *sectionHeader;
@property(nonatomic, strong)NSArray *sectionFooter;

@property(nonatomic, copy)SCTableViewCellResponseBlock cellResponseBlock;
@property(nonatomic, copy)SCTableViewCellChooseBlock cellChooseBlock;

@end

@implementation SCTableView

- (instancetype)initWithFrame:(CGRect)frame CellClassNames:(NSArray *)cellClassNames NeedDeselect:(BOOL)needDeselect SelectedColor:(UIColor *)selectedColor style:(UITableViewStyle)tableViewStyle {
    self = [super initWithFrame:frame style:tableViewStyle];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 44;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _cellIdentifiers = cellClassNames;
        for (int i = 0; i < cellClassNames.count ; i++) {
            NSString *cellClassName = cellClassNames[i];
            if (NSClassFromString(cellClassName) && [NSClassFromString(cellClassName) isSubclassOfClass:[SCBaseTableCell class]]) {
                
                if ([[NSBundle mainBundle] pathForResource:_cellIdentifiers[i] ofType:@"nib"]) {
                    [self registerNib:[UINib nibWithNibName:cellClassName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellClassName];
                    
                }
                else {
                    [self registerClass:NSClassFromString(cellClassName) forCellReuseIdentifier:cellClassName];
                }
            }
            else {
                _cellIdentifiers = nil;
                break;
            }
        }
        _tempCells = [NSMutableArray array];
        for (int i = 0; i < _cellIdentifiers.count; i++) {
            [_tempCells addObject:[self dequeueReusableCellWithIdentifier:_cellIdentifiers[i]]];
        }
        _needDeselect = needDeselect;
        _selectedColor = selectedColor;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}
- (void)setInfoWihtDict:(NSDictionary *)dict {
    if ([dict objectForKey:DataSource] && [dict[DataSource] isKindOfClass:[NSArray class]] && [dict[DataSource] count] != 0) {
        if ([dict[DataSource][0] isKindOfClass:[NSArray class]]) {
            _myDataSource = dict[DataSource];
        }
        else {
            _myDataSource = [NSArray arrayWithObject:dict[DataSource]];
        }
    }
    else {
        _myDataSource = nil;
    }
    
    
    if ([dict objectForKey:SectionFooter] && [dict[SectionFooter] isKindOfClass:[NSArray class]]) {
        _sectionFooter = dict[SectionFooter];
    }
    else {
        _sectionFooter = nil;
    }
    
    if ([dict objectForKey:SectionHeader] && [dict[SectionHeader] isKindOfClass:[NSArray class]]) {
        _sectionHeader = dict[SectionHeader];
    }
    else {
        _sectionHeader = nil;
    }
    
    [self reloadData];
}

- (void)setCellResponseBlock:(SCTableViewCellResponseBlock)cellResponseBlock {
    _cellResponseBlock = cellResponseBlock;
}

- (void)setCellChooseBlock:(SCTableViewCellChooseBlock)cellChooseBlock {
    _cellChooseBlock = cellChooseBlock;
}

#pragma mark - UITableViewMethod
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_myDataSource) {
        return _myDataSource.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_myDataSource && _cellIdentifiers.count > 0 && section < _myDataSource.count) {
        return [_myDataSource[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifiers[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row])]];
    SCBaseTableCell *newCell = (SCBaseTableCell *)cell;
    newCell.selectedColor = _selectedColor;
    [newCell loadWithData:_myDataSource[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_needDeselect) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (_cellResponseBlock) {
        _cellResponseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath.section,indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SCBaseTableCell *tempCell = _tempCells[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row])];
    if ([tempCell getCellHeight] > 0) {
        return [tempCell getCellHeight];
    }
    else {
        return UITableViewAutomaticDimension;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_sectionHeader && section < _sectionHeader.count && ([_sectionHeader[section] isKindOfClass:[UIView class]])) {
        return _sectionHeader[section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (_sectionFooter && section < _sectionFooter.count && ([_sectionFooter[section] isKindOfClass:[UIView class]])) {
        return _sectionFooter[section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_sectionHeader && section < _sectionHeader.count && ([_sectionHeader[section] isKindOfClass:[UIView class]])) {
        UIView *view = _sectionHeader[section];
        return view.frame.size.height;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_sectionFooter && section < _sectionFooter.count && ([_sectionFooter[section] isKindOfClass:[UIView class]])) {
        UIView *view = _sectionFooter[section];
        return view.frame.size.height;
    }
    return 0;
}



@end
