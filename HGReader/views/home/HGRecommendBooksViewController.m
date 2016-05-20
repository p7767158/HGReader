//
//  HGRecommendBooksViewController.m
//  HGReader
//
//  Created by zhh on 16/5/20.
//  Copyright © 2016年 zhh. All rights reserved.
//

#import "HGRecommendBooksViewController.h"
#import "HGRecommendBookListCell.h"
#import "HGBook.h"

@interface HGRecommendBooksViewController()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *list;
@property (nonatomic, strong) NSMutableArray *books;
@property (nonatomic, assign) NSInteger page;

@end

@implementation HGRecommendBooksViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _page = 1;
        _books = @[].mutableCopy;
        [HGBook getBooksByPage:self.page succ:^(NSArray *books, NSString *succ) {
            if (self.page == 1) {
                [_books removeAllObjects];
                [_books addObjectsFromArray:books];
            } else {
                [_books addObjectsFromArray:books];
            }
            [self.list reloadData];
        } fail:^{
            
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"推荐列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.list];
    [self.list mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableView *)list
{
    if (!_list) {
        _list = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _list.dataSource = self;
        _list.rowHeight = 160;
        _list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_list registerClass:HGRecommendBookListCell.class forCellReuseIdentifier:recommendBookListCell];
    }
    return _list;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGRecommendBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendBookListCell forIndexPath:indexPath];
    [cell updateWithBook:self.books[indexPath.row]];
    return cell;
}

@end
