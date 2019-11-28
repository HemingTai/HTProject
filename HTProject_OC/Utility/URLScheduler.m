//
//  URLScheduler.m
//  HTProject
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "URLScheduler.h"

@interface URLScheduler()

@property (nonatomic, assign) NSInteger urlSchedulerTag;

@end

@implementation URLScheduler

+ (URLScheduler *)sharedInstance {
    static dispatch_once_t onceToken;
    static URLScheduler *urlScheduler;
	dispatch_once (&onceToken,^{
	  urlScheduler = [[self alloc] init];
	});
	return urlScheduler;
}

//! xxx://x/x(或者带参数xxx://x/x?parameter1&parameter2)解析，并跳转到对应原生页面或者网页
- (void)goToViewControllerWithNavigationController:(UINavigationController *)navigationController
                                               url:(NSString *)url
                                             title:(NSString *)title {
    NSParameterAssert(url);
	if ([url hasPrefix:@"https://"] || [url hasPrefix:@"http://"] || [url hasPrefix:@"www."]) {
		self.urlSchedulerTag = 0;
        [self goToWebViewControllerWithNavigationController:navigationController url:url title:title];
	}
	else if ([url hasPrefix:@"xxx://"]) {
        
    }
}

//! 跳转网页
- (void)goToWebViewControllerWithNavigationController:(UINavigationController *)navigationController
                                                  url:(NSString *)url
                                                title:(NSString *)title {

}

@end
