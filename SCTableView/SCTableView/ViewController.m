//
//  ViewController.m
//  SCTableView
//
//  Created by sobeycloud on 16/3/21.
//  Copyright © 2016年 sobeycloud. All rights reserved.
//

#import "ViewController.h"
#import "SCTableView.h"

@interface ViewController ()
@property(nonatomic ,strong)SCTableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // if you have only one section, you deliver a one dimensional array as datasource.
    __block NSMutableArray *dataSource = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [dataSource addObject:[NSMutableArray arrayWithObject:@{@"title":@"Hello"}]];
    }

    NSMutableArray *headers = [NSMutableArray array];
    NSMutableArray *footers = [NSMutableArray array];
    for (int i = 0; i < dataSource.count; i++) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, i*30)];
        header.backgroundColor = [UIColor greenColor];
        [headers addObject:header];
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        footer.backgroundColor = [UIColor lightGrayColor];
        [footers addObject:footer];
    }
    
    SCTableView *tableView = [[SCTableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) NeedDeselect:NO SelectedColor:[UIColor cyanColor] style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setCellChooseBlock:^NSString *(NSDictionary *data, NSIndexPath *indexPath) {
        return @"SCLeftImageTextCell";
    }];
    [tableView setInfoWihtDict:@{SCTableViewDataSource:dataSource,SCTableViewSectionHeader:headers,SCTableViewSectionFooter:footers}];
    [tableView setCellResponseBlock:^(NSDictionary *data, NSIndexPath *indexPath) {
        NSLog(@"section %ld %@ %ld.",indexPath.section,[data objectForKey:@"title"],indexPath.row);
    }];
    [self.view addSubview:tableView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
