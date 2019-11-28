//
//  HTAES.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTAES : NSObject

+ (NSString *)aesEncryptString:(NSString *)string withKey:(NSString *)key;

+ (NSData *)aesEncryptData:(NSData *)data withKey:(NSString *)key;



+ (NSString *)aesDecryptString:(NSString *)string withKey:(NSString *)key;

+ (NSData *)aesDecryptData:(NSData *)data withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
