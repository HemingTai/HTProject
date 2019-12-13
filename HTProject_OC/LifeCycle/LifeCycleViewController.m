//
//  LifeCycleViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/5.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "LifeCycleViewController.h"
#import "HTHeaderView.h"

@interface LifeCycleViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LifeCycleViewController

/************************ view的生命周期 ***************************************************************
 * view的生命周期分别调用一下方法：loadView -> viewDidLoad -> viewWillAppear -> viewWillLayoutSubviews ->
 * viewDidLayoutSubviews -> viewDidAppear -> viewWillDisappear -> viewDidDisappear -> dealloc
 *****************************************************************************************************/

- (void)loadView {
    [super loadView];
    NSLog(@"--loadView");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    NSLog(@"--viewDidLoad");
    [self initializeSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"--viewWillAppear");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"--viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"--viewDidLayoutSubviews");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"--viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"--viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"--viewDidDisappear");
}

- (void)dealloc {
    NSLog(@"--dealloc");
}

//MARK: ------ functions ------

- (void)initializeSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    HTHeaderView *header = [[HTHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    self.tableView.tableHeaderView = header;//被添加至父视图中，延时调用
    [header layoutIfNeeded];//立即调用
    NSLog(@"--------------分割线--------------");
    [header layoutIfNeeded];
    [self.view addSubview:header];//被添加至父视图中，延时调用
    
//    header.frame = CGRectMake(0, 0, 300, 30);//自身大小变化，立即调用
//    header.frame = CGRectMake(20, 0, kScreenWidth, 30);//注意：自身大小指的是宽或高，位置发生变化时是不会被调用的
    
    [header addTitleLabel];//添加子视图时，延时调用
    [header layoutIfNeeded];//立即调用

    [header updateTitleLabel];//子视图大小变化，立即调用
}

@end
