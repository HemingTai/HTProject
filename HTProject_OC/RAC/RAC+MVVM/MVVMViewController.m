//
//  MVVMViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "MVVMViewController.h"
#import "MVVMHeaderView.h"
#import "MVVMTableViewCell.h"
#import "ViewModel.h"
#import "HTModel.h"

@interface MVVMViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) ViewModel *vm;
@property(nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MVVMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.dataArray = [[NSMutableArray alloc] init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = UIColor.whiteColor;
    [_tableView registerClass:[MVVMTableViewCell class] forCellReuseIdentifier:@"reuseId"];
    [self.view addSubview:_tableView];
    
    MVVMHeaderView * headerView = [[MVVMHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    self.tableView.tableHeaderView = headerView;
    
    self.vm = [[ViewModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.vm initWithSuccess:^(NSArray * _Nonnull array) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.dataArray removeAllObjects];
        [strongSelf.dataArray addObjectsFromArray:array];
        [strongSelf.tableView reloadData];
        headerView.dataArray = [strongSelf.dataArray copy];
    } failure:^(NSError * _Nonnull error) {}];
}

#pragma mark ------ UITableViewDelegate, UITableViewDataSource ------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVVMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseId"];
    cell.titleLabel.text = ((HTModel *)self.dataArray[indexPath.row]).title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.vm.contentKey = ((HTModel *)self.dataArray[indexPath.row]).title;
}

@end
