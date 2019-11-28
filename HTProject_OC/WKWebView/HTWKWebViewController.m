//
//  HTWKWebViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/11/4.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTWKWebViewController.h"
#import "GJRefreshGifHeader.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import <MJRefresh.h>

@interface HTWKWebViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkwebView;

@end

@implementation HTWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.wkwebView];
    [self.wkwebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    [self loadUrl];
}

- (void)loadUrl {
    NSString *urlStr = @"https://www.baidu.com";
    [self.wkwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    [webView.scrollView.mj_header beginRefreshing];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [webView.scrollView.mj_header endRefreshing];
    NSLog(@"加载完成");
}

#pragma mark - setter&&getter

- (WKWebView *)wkwebView {
    if (!_wkwebView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;
        config.allowsPictureInPictureMediaPlayback = YES;
        _wkwebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _wkwebView.navigationDelegate = self;
        _wkwebView.backgroundColor = UIColor.whiteColor;
        _wkwebView.scrollView.backgroundColor = UIColor.whiteColor;
        GJRefreshGifHeader *header = [GJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadUrl)];
        _wkwebView.scrollView.mj_header = header;
    }
    return _wkwebView;
}

@end
