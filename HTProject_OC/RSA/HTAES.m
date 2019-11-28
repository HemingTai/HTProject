//
//  HTAES.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/29.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "HTAES.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

@implementation HTAES

+ (NSString *)aesEncryptString:(NSString *)string withKey:(NSString *)key {
    const char *cStr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:[string length]];
    //对数据进行加密
    NSData *result = [self aesEncryptData:data withKey:key];
    //转换为2进制字符串
    if(result && result.length > 0) {
        Byte *datas = (Byte *)[result bytes];
        NSMutableString *outPut = [NSMutableString stringWithCapacity:result.length];
        for(int i = 0 ; i < result.length ; i++) {
            [outPut appendFormat:@"%02x",datas[i]];
        }
        return outPut;
    }
    return nil;
}

+ (NSData *)aesEncryptData:(NSData *)data withKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(key) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,//加解密方式：kCCEncrypt 加密，kCCDecrypt 解密
                                          kCCAlgorithmAES,//加密算法
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,//填充模式
                                          keyPtr,//密钥长度
                                          kCCBlockSizeAES128,//加密块大小
                                          NULL,
                                          [data bytes],//待加密数据大小
                                          dataLength,//待加密数据长度
                                          buffer,
                                          bufferSize,//加密后数据大小
                                          &numBytesEncrypted);//已加密字节数
    if(cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSString *)aesDecryptString:(NSString *)string withKey:(NSString *)key {
    NSMutableData *data = [NSMutableData dataWithCapacity:string.length/2.0];
    unsigned char whole_bytes;
    char byte_chars[3] = {'\0','\0','\0'};
    for(int i = 0 ; i < [string length]/2 ; i++) {
        byte_chars[0] = [string characterAtIndex:i * 2];
        byte_chars[1] = [string characterAtIndex:i * 2 + 1];
        whole_bytes = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_bytes length:1];
    }
    NSData *result = [self aesDecryptData:data withKey:key];
    if(result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSData *)aesDecryptData:(NSData *)data withKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end
