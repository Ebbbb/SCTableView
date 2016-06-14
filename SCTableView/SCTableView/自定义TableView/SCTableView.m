//
//  SCTableView.m
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCTableView.h"
#import "UITableViewCell+BaseConfiguration.h"
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
@property(nonatomic, copy)SCTableViewDidEditCallBackBlock editCallBack;
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
            Class cellClass = NSClassFromString(cellClassName);
            if (cellClass && [[[cellClass alloc] init] conformsToProtocol:@protocol(SCBaseTableCellInterFace)]) {
                
                if ([[NSBundle mainBundle] pathForResource:_cellIdentifiers[i] ofType:@"nib"]) {
                    [self registerNib:[UINib nibWithNibName:cellClassName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellClassName];
                    
                }
                else {
                    [self registerClass:cellClass forCellReuseIdentifier:cellClassName];
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

- (void)setDidEditCallBackBlock:(SCTableViewDidEditCallBackBlock)editCallBack {
    _editCallBack = editCallBack;
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifiers[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath)]];
    if ([_cellIdentifiers[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath)] isEqualToString:@"SCTableRelateVideoCell"]) {
        NSLog(@"%@",cell.child);
    }
    cell.selectedColor = _selectedColor;
    cell.indexPath = indexPath;
    [cell.child dealWithData:_myDataSource[indexPath.section][indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_needDeselect) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (_cellResponseBlock) {
        _cellResponseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tempCell = _tempCells[_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath)];
    [tempCell.child dealWithData:_myDataSource[indexPath.section][indexPath.row]];
    if ([tempCell.child respondsToSelector:@selector(getSubCellHeight)] && [tempCell.child getSubCellHeight] > 0) {
        return [tempCell.child getSubCellHeight];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.editing;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.editing;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleInsert;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if ([_myDataSource[sourceIndexPath.section] isKindOfClass:[NSMutableArray class]] && [_myDataSource[destinationIndexPath.section] isKindOfClass:[NSMutableArray class]]) {
        
        NSMutableArray *sourceArray = (NSMutableArray *)_myDataSource[sourceIndexPath.section];
        NSMutableArray *destinationArray = (NSMutableArray *)_myDataSource[destinationIndexPath.section];
        if (sourceIndexPath.section == destinationIndexPath.section) {
            [sourceArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        }
        else {
            [destinationArray insertObject:sourceArray[sourceIndexPath.row] atIndex:destinationIndexPath.row];
            [sourceArray removeObjectAtIndex:sourceIndexPath.row];
        }
        if (_editCallBack){
            _editCallBack(_myDataSource);
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_myDataSource[indexPath.section] isKindOfClass:[NSMutableArray class]]) {
         NSMutableArray *array = (NSMutableArray *)_myDataSource[indexPath.section];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [array removeObjectAtIndex:indexPath.row];
            [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self reloadData];
        }
        if (_editCallBack){
            _editCallBack(_myDataSource);
        }
        
    }
}



@end
