//
//  AllDemoViewController.m
//  Demo
//
//  Created by Mr.Tai on 16/5/10.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//  Demo集合首页

#import "AllDemoViewController.h"
#import "FirstDemoController.h"
#import "SecondDemoController.h"
#import "ThirdDemoController.h"
#import "SixthDemoController.h"

@interface AllDemoViewController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AllDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Demo集合";
    
    _dataArray = @[@"获取内存及空间信息",@"获取已安装应用列表",@"水波纹效果",@"CAShapeLayer集合"];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView.frame = CGRectZero;
    [self.view addSubview:_tableView];
}

#pragma mark ---------TableView代理方法---------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            FirstDemoController *fvc = [[FirstDemoController alloc] init];
            [self.navigationController pushViewController:fvc animated:YES];
        }
            break;
        case 1: {
            SecondDemoController *svc = [[SecondDemoController alloc]init];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        case 2: {
            ThirdDemoController *tvc = [[ThirdDemoController alloc]init];
            [self.navigationController pushViewController:tvc animated:YES];
        }
            break;
        case 3: {
            SixthDemoController *svc = [[SixthDemoController alloc]init];
            [self.navigationController pushViewController:svc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
