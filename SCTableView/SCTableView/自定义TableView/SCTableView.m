//
//  SCTableView.m
//  SCTest
//
//  Created by sobeycloud on 16/2/1.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "SCTableView.h"

NSString * const SCTableViewDataSource = @"SCTableViewDataSource";
NSString * const SCTableViewSectionHeader = @"SCTableViewSectionHeader";
NSString * const SCTableViewSectionFooter = @"SCTableViewSectionFooter";

@interface SCTableView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSMutableDictionary *tempCellDic;
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

- (instancetype)initWithFrame:(CGRect)frame NeedDeselect:(BOOL)needDeselect SelectedColor:(UIColor *)selectedColor style:(UITableViewStyle)tableViewStyle {
    self = [super initWithFrame:frame style:tableViewStyle];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.estimatedRowHeight = 44;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    if ([dict objectForKey:SCTableViewDataSource]) {
        if ([dict[SCTableViewDataSource] isKindOfClass:[NSArray class]]) {
            if ([dict[SCTableViewDataSource] count] > 0) {
                if ([dict[SCTableViewDataSource][0] isKindOfClass:[NSArray class]] || [dict[SCTableViewDataSource][0] isKindOfClass:[NSMutableArray class]]) {
                    _myDataSource = dict[SCTableViewDataSource];
                }
                else {
                    _myDataSource = [NSArray arrayWithObject:dict[SCTableViewDataSource]];
                }
            }else{
                _myDataSource = dict[SCTableViewDataSource];
            }
        }
        else {
            NSAssert(0, @"SCTableview datasource is not an array!");
        }
    }
    
    
    if ([dict objectForKey:SCTableViewSectionFooter]) {
        if ([dict[SCTableViewSectionFooter] isKindOfClass:[NSArray class]]) {
            _sectionFooter = dict[SCTableViewSectionFooter];
        }
        else {
            NSAssert(0, @"SCTableview sectionfooter is not an array!");
        }
    }
    
    
    if ([dict objectForKey:SCTableViewSectionHeader]) {
        if ([dict[SCTableViewSectionHeader] isKindOfClass:[NSArray class]]) {
            _sectionHeader = dict[SCTableViewSectionHeader];
        }
        else {
            NSAssert(0, @"SCTableview sectionheader is not an array!");
        }
    }
    
    
    [self reloadData];
}

- (void)setCellResponseBlock:(SCTableViewCellResponseBlock)cellResponseBlock {
    _cellResponseBlock = cellResponseBlock;
}

- (void)setCellChooseBlock:(SCTableViewCellChooseBlock)cellChooseBlock {
    _cellChooseBlock = cellChooseBlock;
}

- (NSString *)getCellNameWithData:(NSDictionary *)data AndIndexPath:(NSIndexPath *)indexPath {
    if (!_tempCellDic) {
        _tempCellDic = [NSMutableDictionary dictionary];
    }
    NSString *cellClassName = _cellChooseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath);
    if (![_tempCellDic objectForKey:_cellChooseBlock(_myDataSource[indexPath.section][indexPath.row], indexPath)]) {
        Class cellClass = NSClassFromString(cellClassName);
        if (cellClass && [[[cellClass alloc] init] conformsToProtocol:@protocol(SCBaseTableCellInterFace)]) {
            if ([[NSBundle mainBundle] pathForResource:cellClassName ofType:@"nib"]) {
                [self registerNib:[UINib nibWithNibName:cellClassName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellClassName];
                
            }
            else {
                [self registerClass:cellClass forCellReuseIdentifier:cellClassName];
            }
        }
        else {
            NSAssert(0, @"Cell (%@) is not existent!",cellClassName);
        }
        _tempCellDic[cellClassName] = [self dequeueReusableCellWithIdentifier:cellClassName];
    }
    return cellClassName;
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
    if (_myDataSource && section < _myDataSource.count) {
        return [_myDataSource[section] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:[self getCellNameWithData:_myDataSource[indexPath.section][indexPath.row] AndIndexPath:indexPath]];
    cell.selectedColor = _selectedColor;
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
    UITableViewCell *tempCell = _tempCellDic[[self getCellNameWithData:_myDataSource[indexPath.section][indexPath.row] AndIndexPath:indexPath]];
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
    UIView * footer = [[UIView alloc]init];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_sectionHeader && section < _sectionHeader.count && ([_sectionHeader[section] isKindOfClass:[UIView class]])) {
        UIView *view = _sectionHeader[section];
        return view.frame.size.height;
    }
    return 0.000000001;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_sectionFooter && section < _sectionFooter.count && ([_sectionFooter[section] isKindOfClass:[UIView class]])) {
        UIView *view = _sectionFooter[section];
        return view.frame.size.height;
    }
    return 0.00000001;
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
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
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
