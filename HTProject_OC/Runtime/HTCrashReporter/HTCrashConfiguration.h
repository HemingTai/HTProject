//
//  HTCrashConfiguration.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/24.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <UIKit/UIKit.h>

// !!!: ==================== Macro ====================

#if DEBUG
    #define NSLog(...) printf("%s(%d): %s\n",__FUNCTION__,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#endif

// !!!: ==================== Const ====================

//! 日志标题线
UIKIT_EXTERN NSString * const HTCrashReporterTitleSeparator;
//! 日志分隔线
UIKIT_EXTERN NSString * const HTCrashReporterBottomSeparator;

// !!!: ==================== Enums ====================

//! 崩溃类型
typedef NS_OPTIONS(NSUInteger, HTCrashType) {
    //! 字符串下标或范围越界
    HTCrashTypeStringRangeOrIndexOutOfBounds = 1 << 0,
    //! 可变数组特有崩溃
    HTCrashTypeMutableArrayOwned = 1 << 1,
    //! 数组越界
    HTCrashTypeArrayIndexBeyondBounds = 1 << 2,
    //! 数组插入nil对象
    HTCrashTypeArrayAttemptToInsertNilObject = 1 << 3,
    //! KVC赋值
    HTCrashTypeObjectKVC = 1 << 4,
    //! 未找到方法
    HTCrashTypeObjectUnrecognizedSelectorSentToInstance = 1 << 5,
    //! 定时器未被清除
    HTCrashTypeTimerIsNotCleaned = 1 << 6,
    //! 字典所有崩溃
    HTCrashTypeDictionaryAll = 1 << 7,
    //! 对象所有崩溃
    HTCrashTypeObjectAll = HTCrashTypeObjectKVC|HTCrashTypeObjectUnrecognizedSelectorSentToInstance,
    //! 数组所有崩溃
    HTCrashTypeArrayAll = HTCrashTypeMutableArrayOwned|HTCrashTypeArrayIndexBeyondBounds|HTCrashTypeArrayAttemptToInsertNilObject,
    //! 所有崩溃
    HTCrashTypeAll = HTCrashTypeStringRangeOrIndexOutOfBounds|HTCrashTypeArrayAll|HTCrashTypeDictionaryAll|HTCrashTypeObjectAll|HTCrashTypeTimerIsNotCleaned
};
