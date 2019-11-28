//
//  PageViewController.m
//  HTProject_OC
//
//  Created by Hem1ngTai on 2018/12/29.
//  Copyright © 2018 Hem1ng. All rights reserved.
//

#import "PageViewController.h"
#import "RuntimeViewController.h"
#import "MultiThreadViewController.h"
#import "AllDemoViewController.h"

@interface PageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@property(nonatomic, strong) RuntimeViewController *rvc;
@property(nonatomic, strong) MultiThreadViewController *mvc;
@property(nonatomic, strong) AllDemoViewController *avc;
@property(nonatomic, strong) NSArray *vcArray;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.rvc = [RuntimeViewController new];
    self.mvc = [MultiThreadViewController new];
    self.avc = [AllDemoViewController new];
    self.vcArray = @[self.rvc, self.mvc, self.avc];

    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(0)};
    UIPageViewController *pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    pvc.delegate = self;
    pvc.dataSource = self;
    pvc.view.frame = self.view.bounds;
    [pvc setViewControllers:@[self.rvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pvc];
    nav.navigationBar.translucent = NO;
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.vcArray.count;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArray indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self.vcArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.vcArray indexOfObject:viewController];
    if (index == self.vcArray.count-1 || index == NSNotFound) {
        return nil;
    }
    index++;
    return [self.vcArray objectAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (finished) {
        NSLog(@"111111");
    }
    if (completed) {
        NSLog(@"222222");
    }
}

@end
