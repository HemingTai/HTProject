//
//  HTUtility.h
//  HTProject
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//  工具类

#import <UIKit/UIKit.h>

@interface HTUtility : NSObject

//MARK: ------------------------ 文件相关 ------------------------
//! 根据文件名获取bundle中的文件
+ (NSString *)getFilePathFromBundleByName:(NSString *)fileName;

//! 根据文件名获取Document中的文件
+ (NSString *)getFilePathFromDocumentByName:(NSString *)fileName;

//! 创建目录
+ (BOOL)createDirectory:(NSString *)dirPath;

//! 清除Cache目录
+ (void)clearCacheDirectory;

//! 删除文件
+ (BOOL)deleteFileAtPath:(NSString *)filePath;

//! 将数据写入文件
+ (BOOL)writeContent:(NSString *)content toFile:(NSString *)fileName;

//MARK: ------------------------ 日期相关 ------------------------
//! 获取年份
+ (NSString *)getYearFromDate:(NSDate *)date;

//! 获取年月
+ (NSString *)getYearMonthFromDate:(NSDate *)date;

//! 获取月日
+ (NSString *)getMonthDayFromDate:(NSDate *)date;

//! 获取年月日
+ (NSString *)getYearMonthDayFromDate:(NSDate *)date;

//! 获取时分秒
+ (NSString *)getTimeFromDate:(NSDate *)date;

//! 获取年月日时分秒
+ (NSString *)getDateTimeFromDate:(NSDate *)date;

//! 获取年月日时分秒毫秒
+ (NSString *)getTimeInterValFromDate:(NSDate *)date;

//! 根据日期和格式获得日期字符串
+ (NSString *)getStringFromDate:(NSDate *)date withFormatter:(NSString *)formatter;

//! 根据日期字符串和格式获得日期
+ (NSDate *)getDateFormString:(NSString *)date withFormatter:(NSString *)formatter;

//! 根据日期获取日期描述，如: 14:30 / 昨天 / 2019-11-26
+ (NSString *)getDateDescWithDateString:(NSString *)dateString;

//MARK: ------------------------ 校验相关 ------------------------
//! 是否是有效字典
+ (BOOL)isValidDictionary:(id)object;

//! 是否是有效数组
+ (BOOL)isValidArray:(id)object;

//! 是否是有效字符串
+ (BOOL)isValidString:(id)object;

@end
