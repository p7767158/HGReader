//
//  HGLocalBookListViewController.m
//  HGReader
//
//  Created by zhh on 16/5/25.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGLocalBookListViewController.h"
#import "HGLocalBook.h"
#import "HGLocalBookListCell.h"
#import "HGReadTxtViewController.h"

@interface HGLocalBookListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *list;
@property (nonatomic, strong) NSMutableArray *books;

@end

@implementation HGLocalBookListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _books = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"书架";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.list];
    [self.list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HGLocalBook getLocalBooks:^(NSArray *localBooks) {
        [self.books removeAllObjects];
        [self.books addObjectsFromArray:localBooks];
        [self.list reloadData];
    }];
}

- (UITableView *)list
{
    if (!_list) {
        _list = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _list.delegate = self;
        _list.dataSource = self;
        _list.rowHeight = 160;
        [_list registerClass:HGLocalBookListCell.class forCellReuseIdentifier:localBookListCell];
    }
    return _list;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGLocalBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:localBookListCell forIndexPath:indexPath];
    [cell updateWithLocalBook:self.books[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGLocalBook *localBook = self.books[indexPath.row];
    [localBook open:^(NSString *txt) {
        HGReadTxtViewController *readVC = [[HGReadTxtViewController alloc] initWithTxtString:txt];
        readVC.hidesBottomBarWhenPushed = YES;
        readVC.navigationItem.title = localBook.name;
        [self.navigationController pushViewController:readVC animated:YES];
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
