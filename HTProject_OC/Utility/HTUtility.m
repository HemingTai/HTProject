//
//  HTUtility.m
//  HTProject
//
//  Created by Hem1ng on 2019/11/25.
//  Copyright © 2019 Hem1ngT4i. All rights reserved.
//

#import "HTUtility.h"

@implementation HTUtility

+ (NSString *)getFilePathFromBundleByName:(NSString *)fileName {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+ (NSString *)getFilePathFromDocumentByName:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docPath = [paths objectAtIndex:0];
	return [docPath stringByAppendingPathComponent:fileName];
}

+ (BOOL)createDirectory:(NSString *)dirPath {
	return [[NSFileManager defaultManager] createDirectoryAtPath:dirPath
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:nil];
}

+ (void)clearCacheDirectory {
    NSURL *cacheURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSMutableArray *pathsToDelete = [NSMutableArray array];
    NSArray *cacheArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:cacheURL includingPropertiesForKeys:nil options:0 error:nil];
    for (NSURL *cache in cacheArray) {
        NSString *fileName = cache.lastPathComponent;
        if ([fileName hasSuffix: @".txt"]) {
            continue;
        }
        else {
            [pathsToDelete addObject:cache];
        }
    }
    [pathsToDelete enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:obj error:&error];
    }];
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
    return NO;
}

+ (BOOL)writeContent:(NSString *)content toFile:(NSString *)fileName {
    if (content) {
        NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        unsigned long long fileLength = 0;
        if (fileHandle == nil) {
            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
            fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        }
        else {
            fileLength = [fileHandle seekToEndOfFile];
        }
        if (fileLength > 1024 * 50) {
            [fileHandle truncateFileAtOffset:0];
        }
        [fileHandle writeData:data];
        [fileHandle closeFile];
        return YES;
    }
    return NO;
}

+ (NSString *)getYearFromDate:(NSDate *)date {
    return [self getStringFromDate:date withFormatter:@"yyyy"];
}

+ (NSString *)getYearMonthFromDate:(NSDate *)date {
	return [self getStringFromDate:date withFormatter:@"yyyyMM"];
}

+ (NSString *)getMonthDayFromDate:(NSDate *)date {
    return [self getStringFromDate:date withFormatter:@"MMdd"];
}

+ (NSString *)getYearMonthDayFromDate:(NSDate *)date {
	return [self getStringFromDate:date withFormatter:@"yyyyMMdd"];
}

+ (NSString *)getTimeFromDate:(NSDate *)date {
    return [self getStringFromDate:date withFormatter:@"HHmmss"];
}

+ (NSString *)getDateTimeFromDate:(NSDate *)date {
	return [self getStringFromDate:date withFormatter:@"yyyyMMddHHmmss"];
}

+ (NSString *)getTimeInterValFromDate:(NSDate *)date {
	return [self getStringFromDate:date withFormatter:@"yyyyMMddHHmmssSSSSSS"];
}

+ (NSString *)getStringFromDate:(NSDate *)date withFormatter:(NSString *)formatter {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatter];
	return [dateFormatter stringFromDate:date];
}

+ (NSDate *)getDateFormString:(NSString *)date withFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:date];
}

//! 日期时间格式：如：14:30 / 昨天 / 2015-12-29
+ (NSString *)getDateDescWithDateString:(NSString *)dateString {
    NSDate *curDate = [NSDate date];
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [inputFormatter dateFromString:dateString];
    //计算与当前时间相差秒数
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger isNowday = [cmp2 day] - [cmp1 day];
    NSTimeInterval retTime = 1.0;
    if (time < 3600) {//小于一小时
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    }
    else if (time < 3600*6 ) {//小于6小时
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    }
    else if (isNowday == 0) {//今天
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        return [formatter stringFromDate:date];
    }
    else if (isNowday == 1) {// 昨天
            return @"昨天";
    }
    else {//第一个条件是同年且相隔时间在一个月内；第二个条件是隔年，对于隔年只能是去年12月与今年1月这种情况
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        return [formatter stringFromDate:date];
    }
}

+ (BOOL)isValidDictionary:(id)object {
	return object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).count;
}

+ (BOOL)isValidArray:(id)object {
	return object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count;
}

+ (BOOL)isValidString:(id)object {
	return object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length;
}

@end
