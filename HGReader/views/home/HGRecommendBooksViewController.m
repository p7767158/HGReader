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
#import "HGReadTxtViewController.h"
#import "HGLocalBook.h"
#import "HGBookDB.h"

@interface HGRecommendBooksViewController()<UITableViewDataSource, UITableViewDelegate>

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
        _list.delegate = self;
        _list.rowHeight = 160;
        _list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_list registerClass:HGRecommendBookListCell.class forCellReuseIdentifier:recommendBookListCell];
    }
    return _list;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGBook *book = self.books[indexPath.row];
//    [HGBook tryReadByBid:book.bid succ:^(NSString *previewTxt) {
//        if (previewTxt.length > 0) {
//            HGReadTxtViewController *readVC = [[HGReadTxtViewController alloc] initWithTxtString:previewTxt];
//            readVC.hidesBottomBarWhenPushed = YES;
//            readVC.navigationItem.title = book.name;
//            [self.navigationController pushViewController:readVC animated:YES];
//        }
//        
//    } fail:^{
//        
//    }];
    
    //打开本地图书
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:[book filePath]]) {
        //从DB里读取图书(整理代码时 删除，包括上方import)
        [[HGBookDB sharedHGBookDB] getBookWithBid:book.bid finishBlock:^(NSDictionary *books) {
            HGLocalBook *localBook = books[@(book.bid)];
            [localBook open:^(NSString *txt) {
                HGReadTxtViewController *readVC = [[HGReadTxtViewController alloc] initWithTxtString:txt];
                readVC.hidesBottomBarWhenPushed = YES;
                readVC.navigationItem.title = book.name;
                [self.navigationController pushViewController:readVC animated:YES];
            }];
        }];
    } else {
        [HGBook downloadByBook:book succ:^(HGLocalBook *localBook) {
            [localBook open:^(NSString *txt) {
                HGReadTxtViewController *readVC = [[HGReadTxtViewController alloc] initWithTxtString:txt];
                readVC.hidesBottomBarWhenPushed = YES;
                readVC.navigationItem.title = book.name;
                [self.navigationController pushViewController:readVC animated:YES];
            }];
        } fail:^{
            
        }];
    }
}

@end
