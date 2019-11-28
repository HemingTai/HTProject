//
//  FirstDemoController.m
//  Demo
//
//  Created by Mr.Tai on 16/5/10.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//  获得手机内存空间和使用情况

#import "FirstDemoController.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <sys/mount.h>

@interface FirstDemoController()

@property (nonatomic, strong) UILabel *totalMemoryLabel;
@property (nonatomic, strong) UILabel *usedMemoryLabel;
@property (nonatomic, strong) UILabel *activeMemoryLabel;
@property (nonatomic, strong) UILabel *inactiveMemoryLabel;
@property (nonatomic, strong) UILabel *freeMemoryLabel;
@property (nonatomic, strong) UILabel *availabelMemoryLabel;
@property (nonatomic, strong) UILabel *runMemoryLabel;
@property (nonatomic, strong) UILabel *totalSizeLabel;
@property (nonatomic, strong) UILabel *usedSizeLabel;
@property (nonatomic, strong) UILabel *availabelSizeLabel;

@end

@implementation FirstDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"获得内存及空间信息";
    
    UILabel *seperator1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    seperator1.backgroundColor = [UIColor grayColor];
    [self.view addSubview:seperator1];
    
    self.totalMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.totalMemoryLabel];
    self.usedMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.usedMemoryLabel];
    self.activeMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.activeMemoryLabel];
    self.inactiveMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.inactiveMemoryLabel];
    self.freeMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.freeMemoryLabel];
    self.availabelMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.availabelMemoryLabel];
    self.runMemoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.runMemoryLabel];
    
    UILabel *seperator2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, self.view.frame.size.width, 10)];
    seperator2.backgroundColor = [UIColor grayColor];
    [self.view addSubview:seperator2];
    
    self.totalSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.totalSizeLabel];
    self.usedSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 280, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.usedSizeLabel];
    self.availabelSizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 310, self.view.frame.size.width-20, 20)];
    [self.view addSubview:self.availabelSizeLabel];
    
    [self logMemoryInfo];
    self.totalMemoryLabel.text = [NSString stringWithFormat:@"总内存:%.2fMB",[self getTotalMemorySize]];
    self.totalSizeLabel.text = [NSString stringWithFormat:@"总空间:%.2fGB",[self getTotalDiskSize]];
    self.availabelSizeLabel.text = [NSString stringWithFormat:@"可用空间:%.2fGB",[self getAvailableDiskSize]];
    self.usedSizeLabel.text = [NSString stringWithFormat:@"已用空间:%.2fGB",[self getUsedDiskSize]];
}

//!获得总内存大小
- (float)getTotalMemorySize {
    return ([NSProcessInfo processInfo].physicalMemory)/(1024.0*1024.0);
}

//!获得总空间
-(float)getTotalDiskSize {
    struct statfs buf;
    unsigned long long totalSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        totalSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return (totalSpace*1.0)/(1024*1024*1024);
}

//!获取可用空间
-(float)getAvailableDiskSize {
    struct statfs buf;
    unsigned long long availableSpace = -1;
    if (statfs("/var", &buf) >= 0) {
        availableSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return (availableSpace*1.0)/(1024*1024*1024);
}

//!获取已用空间
-(float)getUsedDiskSize {
    return [self getTotalDiskSize]-[self getAvailableDiskSize];
}

//!获得内存信息
-(void)logMemoryInfo {
    mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
    vm_statistics_data_t vmstat;
    if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS) {
        return ;
    }
    
    double unit = 1024 * 1024;
    double wired = vmstat.wire_count * vm_page_size / unit;
    double active = vmstat.active_count * vm_page_size / unit;
    double inactive = vmstat.inactive_count * vm_page_size / unit;
    double free = vmstat.free_count * vm_page_size / unit;
    
    //获取当前应用占用内存
    task_basic_info_64_data_t info;
    unsigned size = sizeof (info);
    task_info (mach_task_self(), TASK_BASIC_INFO_64, (task_info_t)&info, &size);
    double resident = info.resident_size / unit;
    
    self.usedMemoryLabel.text = [NSString stringWithFormat:@"已使用内存(不可分页):%.2lfMB", wired];
    self.activeMemoryLabel.text = [NSString stringWithFormat:@"活跃内存(可分页):%.2lfMB", active];
    //不活跃的，内存不足时，应用就可以抢占这部分内存，也可看作空闲内存
    self.inactiveMemoryLabel.text = [NSString stringWithFormat:@"不活跃内存:%.2lfMB", inactive];
    self.freeMemoryLabel.text = [NSString stringWithFormat:@"空闲内存:%.2lfMB", free];
    self.runMemoryLabel.text = [NSString stringWithFormat:@"当前应用占用内存:%.2lfMB", resident];
    self.availabelMemoryLabel.text = [NSString stringWithFormat:@"可用内存:%.2lfMB",free+inactive];
}

@end
