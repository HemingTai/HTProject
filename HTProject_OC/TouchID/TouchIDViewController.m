//
//  TouchIDViewController.m
//  TouchIDDemo
//
//  Created by heming on 16/12/1.
//  Copyright © 2016年 Mr.Tai. All rights reserved.
//

#import "TouchIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface TouchIDViewController()

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *validBtn;

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"指纹识别";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, 200, 150, 40)];
    self.descriptionLabel.hidden = YES;
    self.descriptionLabel.text = @"验证通过";
    self.descriptionLabel.layer.cornerRadius = 5;
    self.descriptionLabel.clipsToBounds = YES;
    self.descriptionLabel.center = self.view.center;
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.descriptionLabel];
    
    self.validBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.validBtn.frame = CGRectMake((self.view.frame.size.width-150)/2, 200, 150, 40);
    self.validBtn.backgroundColor = [UIColor orangeColor];
    self.validBtn.layer.cornerRadius = 5;
    self.validBtn.center = self.view.center;
    [self.validBtn setTitle:@"验证指纹" forState:UIControlStateNormal];
    [self.validBtn addTarget:self action:@selector(validTouchID) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.validBtn];
}

//! 指纹验证
- (void)validTouchID {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //获取上下文
        LAContext *myContext = [[LAContext alloc] init];
        NSError *error = nil;
        
        /*!
         *@abstract 判断设备是否支持指纹识别
         *@param    LAPolicyDeviceOwnerAuthenticationWithBiometrics 指纹验证
         *@return   YES:支持 NO:不支持
         */
        if([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            /*!
             *@abstract 指纹验证以及回调
             *@param    LAPolicyDeviceOwnerAuthenticationWithBiometrics 指纹验证
             *@param    localizedReason 进行指纹验证时的弹窗的展示内容（该参数不能为nil或者空串，否则会抛出异常）
             *@param    reply:验证后的回调block
             */
            [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                      localizedReason:@"通过Home键验证已有指纹"
                                reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        self.descriptionLabel.hidden = NO;
                        self.validBtn.hidden = YES;
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.validBtn.hidden = NO;
                        self.descriptionLabel.hidden = YES;
                        __block NSString *message = @"";
                        switch (error.code) {
                            case LAErrorAuthenticationFailed: /// 连续三次指纹识别错误
                                message = @"授权失败！";
                                break;
                            case LAErrorUserCancel: /// 在TouchID对话框中点击了取消按钮
                                message = @"用户取消验证Touch ID！";
                                break;
                            case LAErrorUserFallback: /// 在TouchID对话框中点击了输入密码按钮
                                dispatch_async(dispatch_get_main_queue(), ^ {
                                    message = @"用户选择输入密码！";
                                });
                                break;
                            case LAErrorSystemCancel: /// TouchID对话框被系统取消，例如按下Home或者电源键
                                message = @"系统取消授权，如其他应用进入前台，用户按下Home或者电源键！";
                                break;
                            case LAErrorPasscodeNotSet: /// 已录入指纹但设备未设置密码
                                message = @"设备未设置密码！";
                                break;
                        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
                            case LAErrorBiometryNotAvailable: /// TouchID不可用
                                message = @"Touch ID不可用！";
                                break;
                            case LAErrorBiometryNotEnrolled:/// 用户未录入指纹
                                message = @"用户未录入指纹！";
                                break;
                            case LAErrorBiometryLockout: /// 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                                message = @"Touch ID被锁，需要用户输入密码解锁！";
                                break;
                        #endif
                            case LAErrorAppCancel: /// 如突然来了电话，电话应用进入前台，APP被挂起
                                message = @"用户不能控制情况下APP被挂起！";
                                break;
                            case LAErrorInvalidContext: /// -10 LAContext传递给这个调用之前已经失效
                                message = @"LAContext传递给这个调用之前已经失效！";
                                break;
                            default:
                                message = @"其他情况，切换主线程处理！";
                                break;
                        }
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"验证失败！" message:message preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        [alertController addAction:cancelAction];
                        [self presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }];
        }
        else {
            NSString *message = @"";
            switch (error.code) {
                case LAErrorAuthenticationFailed: /// 连续三次指纹识别错误
                        message = @"授权失败！";
                        break;
                    case LAErrorUserCancel: /// 在TouchID对话框中点击了取消按钮
                        message = @"用户取消验证Touch ID！";
                        break;
                    case LAErrorUserFallback: /// 在TouchID对话框中点击了输入密码按钮
                        message = @"用户选择输入密码！";
                        break;
                    case LAErrorSystemCancel: /// TouchID对话框被系统取消，例如按下Home或者电源键
                        message = @"系统取消授权，如其他应用进入前台，用户按下Home或者电源键！";
                        break;
                    case LAErrorPasscodeNotSet: /// 已录入指纹但设备未设置密码
                        message = @"设备未设置密码！";
                        break;
                #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0
                    case LAErrorBiometryNotAvailable: /// TouchID不可用
                        message = @"Touch ID不可用！";
                        break;
                    case LAErrorBiometryNotEnrolled:/// 用户未录入指纹
                        message = @"用户未录入指纹！";
                        break;
                    case LAErrorBiometryLockout: /// 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        message = @"Touch ID被锁，需要用户输入密码解锁！";
                        break;
                #endif
                    case LAErrorAppCancel: /// 如突然来了电话，电话应用进入前台，APP被挂起
                        message = @"用户不能控制情况下APP被挂起！";
                        break;
                    case LAErrorInvalidContext: /// -10 LAContext传递给这个调用之前已经失效
                        message = @"LAContext传递给这个调用之前已经失效！";
                        break;
                default:
                    message = @"不支持指纹识别！";  /// 不支持指纹
                    break;
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

@end
