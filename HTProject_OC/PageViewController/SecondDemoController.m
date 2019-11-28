//
//  SecondDemoController.m
//  Demo
//
//  Created by Mr.Tai on 16/5/11.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//  获得手机已安装应用列表

#import "SecondDemoController.h"
#include <objc/runtime.h>

@interface SecondDemoController()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SecondDemoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"获得安装应用列表";
    
    _dataArray = [self getInstalledApplications];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _tableView.backgroundColor = [UIColor grayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

//!获得已安装应用列表
- (NSArray *)getInstalledApplications {
    NSMutableArray *appInfoArray = [[NSMutableArray alloc]init];
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    Class LSApplicationProxy_class = object_getClass(@"LSApplicationProxy");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray *listApp = [workspace performSelector:@selector(allApplications)];
    for (LSApplicationProxy_class in listApp) {
        NSString *localizedName = [LSApplicationProxy_class performSelector:@selector(localizedName)];
        NSString *applicationType = [LSApplicationProxy_class performSelector:@selector(applicationType)];
        if (![applicationType isEqualToString:@"System"]) {
            [appInfoArray addObject:localizedName];
        }
        /*
        NSObject *description = [LSApplicationProxy_class performSelector:@selector(description)];
        NSObject *resourcesDirectoryURL = [LSApplicationProxy_class performSelector:@selector(resourcesDirectoryURL)];
        NSString *bundleID = [LSApplicationProxy_class performSelector:@selector(applicationIdentifier)];
        NSString *version = [LSApplicationProxy_class performSelector:@selector(bundleVersion)];
        NSString *teamID = [LSApplicationProxy_class performSelector:@selector(teamID)];
        NSArray  *groupIdentifiers = [LSApplicationProxy_class performSelector:@selector(groupIdentifiers)];
        NSInteger originalInstallType = [LSApplicationProxy_class performSelector:@selector(originalInstallType)];
        NSInteger installType = [LSApplicationProxy_class performSelector:@selector(installType)];
        NSNumber *itemID = [LSApplicationProxy_class performSelector:@selector(itemID)];
        NSObject *iconStyleDomain = [LSApplicationProxy_class performSelector:@selector(iconStyleDomain)];
        NSObject *localizedShortName = [LSApplicationProxy_class performSelector:@selector(localizedShortName)];
        NSObject *privateDocumentTypeOwner = [LSApplicationProxy_class performSelector:@selector(privateDocumentTypeOwner)];
        NSObject *privateDocumentIconNames = [LSApplicationProxy_class performSelector:@selector(privateDocumentIconNames)];
        NSObject *installProgress = [LSApplicationProxy_class performSelector:@selector(installProgress)];
        NSObject *appStoreReceiptURL = [LSApplicationProxy_class performSelector:@selector(appStoreReceiptURL)];
        NSNumber *storeFront = [LSApplicationProxy_class performSelector:@selector(storeFront)];
        NSNumber *staticDiskUsage = [LSApplicationProxy_class performSelector:@selector(staticDiskUsage)];
        NSObject *deviceIdentifierForVendor = [LSApplicationProxy_class performSelector:@selector(deviceIdentifierForVendor)];
        NSArray  *requiredDeviceCapabilities = [LSApplicationProxy_class performSelector:@selector(requiredDeviceCapabilities)];
        NSArray  *appTags = [LSApplicationProxy_class performSelector:@selector(appTags)];
        NSArray  *plugInKitPlugins = [LSApplicationProxy_class performSelector:@selector(plugInKitPlugins)];
        NSArray  *VPNPlugins = [LSApplicationProxy_class performSelector:@selector(VPNPlugins)];
        NSArray  *externalAccessoryProtocols = [LSApplicationProxy_class performSelector:@selector(externalAccessoryProtocols)];
        NSArray  *audioComponents = [LSApplicationProxy_class performSelector:@selector(audioComponents)];
        NSArray  *UIBackgroundModes = [LSApplicationProxy_class performSelector:@selector(UIBackgroundModes)];
        NSArray  *directionsModes = [LSApplicationProxy_class performSelector:@selector(directionsModes)];
        NSDictionary *groupContainers = [LSApplicationProxy_class performSelector:@selector(groupContainers)];
        NSString *vendorName = [LSApplicationProxy_class performSelector:@selector(vendorName)];
        NSString *sdkVersion = [LSApplicationProxy_class performSelector:@selector(sdkVersion)];
        [dict setValue:version forKey:@"bundleVersion"];
        [dict setValue:teamID forKey:@"teamID"];
        [dict setValue:groupIdentifiers forKey:@"groupIdentifiers"];
        [dict setValue:@(originalInstallType) forKey:@"originalInstallType"];
        [dict setValue:@(installType) forKey:@"installType"];
        [dict setValue:itemID forKey:@"itemID"];
        [dict setValue:itemID forKey:@"itemID"];
        [dict setValue:iconStyleDomain forKey:@"iconStyleDomain"];
        [dict setValue:localizedShortName forKey:@"localizedShortName"];
        [dict setValue:privateDocumentTypeOwner forKey:@"privateDocumentTypeOwner"];
        [dict setValue:privateDocumentIconNames forKey:@"privateDocumentIconNames"];
        [dict setValue:installProgress forKey:@"installProgress"];
        [dict setValue:appStoreReceiptURL forKey:@"appStoreReceiptURL"];
        [dict setValue:storeFront forKey:@"storeFront"];
        [dict setValue:staticDiskUsage forKey:@"staticDiskUsage"];
        [dict setValue:deviceIdentifierForVendor forKey:@"deviceIdentifierForVendor"];
        [dict setValue:requiredDeviceCapabilities forKey:@"requiredDeviceCapabilities"];
        [dict setValue:appTags forKey:@"appTags"];
        [dict setValue:plugInKitPlugins forKey:@"plugInKitPlugins"];
        [dict setValue:VPNPlugins forKey:@"VPNPlugins"];
        [dict setValue:externalAccessoryProtocols forKey:@"externalAccessoryProtocols"];
        [dict setValue:audioComponents forKey:@"audioComponents"];
        [dict setValue:UIBackgroundModes forKey:@"UIBackgroundModes"];
        [dict setValue:directionsModes forKey:@"directionsModes"];
        [dict setValue:groupContainers forKey:@"groupContainers"];
        [dict setValue:vendorName forKey:@"vendorName"];
        [dict setValue:sdkVersion forKey:@"sdkVersion"];
        */
    }
    return [appInfoArray copy];
}

#pragma mark ---------TableView代理方法---------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

@end
