//
//  LifeCycleViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/12/5.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "LifeCycleViewController.h"

@interface LifeCycleViewController ()

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

@end
