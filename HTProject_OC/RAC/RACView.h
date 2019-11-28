//
//  RACView.h
//  HTProject_OC
//
//  Created by Hem1ngTai on 2019/3/28.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACView : UIView

@property(nonatomic, strong) RACSubject *btnClickSignal;

@end

NS_ASSUME_NONNULL_END
