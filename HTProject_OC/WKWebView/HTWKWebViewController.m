//
//  HTWKWebViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTWKWebViewController.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import <MJRefresh.h>

@interface HTWKWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation HTWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = YES;
    config.allowsPictureInPictureMediaPlayback = YES;
    self.wkwebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    self.wkwebView.navigationDelegate = self;
    self.wkwebView.backgroundColor = UIColor.whiteColor;
    self.wkwebView.scrollView.backgroundColor = UIColor.whiteColor;
    //在网页未加载完成之前添加上拉加载会出现上拉加载跑到顶部的情况，为了解决这个问题，建议在加载完成或者失败的代理方法里添加底部刷新控件
//    self.wkwebView.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self loadUrl];
//    }];
    [self.view addSubview:self.wkwebView];
    [self.wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self loadUrl];
}

- (void)loadUrl {
    NSString *urlStr = @"https://www.baiduddd.com";
    [self.wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15]];
}

//MARK: ------ WKNavigationDelegate ------
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载网页");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"加载完成");
    if (!self.wkwebView.scrollView.mj_footer) {
        self.wkwebView.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadUrl];
        }];
    }
    else {
        [webView.scrollView.mj_footer endRefreshing];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    if (!self.wkwebView.scrollView.mj_footer) {
        self.wkwebView.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadUrl];
        }];
    }
    else {
        [webView.scrollView.mj_footer endRefreshing];
    }
}

@end
