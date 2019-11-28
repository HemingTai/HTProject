//
//  HTRSA.h
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/25.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTRSA : NSObject

/*******************************第一种方式直接给出公钥*********************************/

// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
// decrypt base64 encoded string, convert result to data(not base64 encoded)
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;

// return encrypted base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// return encrypted raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;
// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
// decrypt base64 encoded string, convert result to data(not base64 encoded)
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;




/******************************第二种方式公私钥放在本地********************************/

+ (NSString *)rsaEncryptText:(NSString *)text;

+ (NSData *)rsaEncryptData:(NSData *)data;

+ (NSString *)rsaDecryptText:(NSString *)text;

+ (NSData *)rsaDecryptData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
