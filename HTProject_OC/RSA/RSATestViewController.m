//
//  RSATestViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/25.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "RSATestViewController.h"
#import "HTRSA.h"
#import "HTAES.h"

@interface RSATestViewController ()

@end

@implementation RSATestViewController

/************************************ 非对称加密/对称加密 ************************************
 * 1.非对称加密算法：需要两个密钥：公钥（publickey）和私钥（privatekey），公钥与私钥是一对，如果用公钥对数据进行加密，只有用对应的私钥才能
 *   解密。因为加密和解密使用的是两个不同的密钥，所以这种算法叫作非对称加密算法。
 *
 *   非对称加密算法实现机密信息交换的基本过程：甲方生成一对密钥并将公钥公开，需要向甲方发送信息的其他角色（乙方）使用该密钥（甲方的公钥）对机密
 *   信息进行加密后再发送给甲方，甲方再用自己私钥对加密后的信息进行解密。甲方想要回复乙方时正好相反，使用乙方的公钥对数据进行加密，乙方使用自己的
 *   私钥来进行解密。
 *
 *   RSA加密算法规定明文长度不能大于密钥长度,如果大于密钥长度需要分段加密和解密。默认的 RSA 加密实现不允许明文长度超过密钥长度减去
 *   11（单位是字节，也就是 byte）。也就是说，如果我们定义的密钥长度为 1024（单位是位，也就是 bit），生成的密钥长度就是 1024位 / 8位/字节 =
 *   128字节，那么我们需要加密的明文长度不能超过 128字节 - 11字节 = 117字节。也就是说，我们最大能将 117
 *   字节长度的明文进行加密，如果明文长度超出117字节，就要分段加密。
 *
 *   甲方可以使用自己的私钥对机密信息进行签名后再发送给乙方，乙方再用甲方的公钥对甲方发送回来的数据进行验签。
 *
 *   非对称加密算法：RSA、Elgamal、背包算法、Rabin、D-H、ECC（椭圆曲线加密算法）。
 *   使用最广泛的是RSA算法，Elgamal是另一种常用的非对称加密算法。
 *
 * 2.对称加密：数据发信方将明文（原始数据）和加密密钥（key）一起经过特殊加密算法处理后，使其变成复杂的加密密文发送出去。收信方收到密文后，若想
 *           解读原文，则需要使用加密用过的密钥及相同算法的逆算法对密文进行解密，才能使其恢复成可读明文。
 *   对称加密算法：AES算法，DES算法，3DES算法，Blowfish算法，RC2算法等，使用最广泛的是AES算法。
 *
 * 3.两者对比：非对称加密算法强度复杂、安全性依赖于算法与密钥，但是由于其算法复杂，而使得加密解密速度没有对称加密的速度快。
 *           对称加密密钥体制只有一种密钥，并且是非公开的，如果要解密就得让对方知道密钥，所以保证其安全性就是保证密钥的安全。
 *           而非对称加密密钥体制有两种密钥，公钥是公开的，这样就不需要像对称加密那样传输密钥给对方，安全性就大了很多。
 *****************************************************************************************/

/************************************ RSA非对称加密 ************************************
 * iOS中Security框架提供的RSA相关API如下：
 * 生成密钥对
 * SecKeyGeneratePair(parameters, publicKey, privateKey)
 *
 * 对数据进行签名： 私钥，填充方式， 待签名数据，  待签名数据长度，   签名， 签名长度
 * SecKeyRawSign(key, padding, *dataToSign, dataToSignLen, *sign, signLen);
 *
 * 验证已签名的数据： 公钥，填充方式，  已签名数据，  已签名数据长度，  签名， 签名长度
 * SecKeyRawVerify(key, padding, *signedData, signedDataLen, *sign, signLen);
 *
 * 对数据进行加密：公钥， 填充方式， 待加密明文， 待加密明文长度， 加密后的密文，加密后密文长度
 * SecKeyEncrypt(key, padding, *plainText, plainTextLen, cipherText, cipherTextLen);
 *
 * 解密已加密数据L：私钥，填充方式， 已加密的密文， 已加密的密文长度，解密后的明文，解密后明文长度
 * SecKeyDecrypt(key, padding, *cipherText, cipherTextLen, plainText, plainTextLen);
 *
 * 分组加密块数据大小
 * SecKeyGetBlockSize(SecKeyRef key)
 *
 * RSA keySize（密钥长度）有：512，768，1024，2048位，选择长度要和后台保持统一
 * SecPadding（填充方式）会影响最大分组加密数据块的大小，它是一个枚举类型，有三个值：
 * kSecPaddingNone：填充最大数据块为 SecKeyGetBlockSize 大小
 * kSecPaddingPKCS1：填充方式最大数据块为 SecKeyGetBlockSize 大小减去11
 * kSecPaddingOAEP：填充方式最大数据块为 SecKeyGetBlockSize 大小减去 42
 *
 * 签名使用的填充方式为kSecPaddingPKCS1, 支持的签名算法有 sigraw,md2,md5,sha1,sha256,sha224,sha384,sha512
 * RSA加密解密签名，适合小块的数据处理，大量数量需要处理分组逻辑
 *
 *************************************************************************************/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //.pem文件其实是文本格式
    NSString *publicKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rsa_public_key" ofType:@".pem"] encoding:NSUTF8StringEncoding error:nil];
    NSString *ret = [HTRSA encryptString:@"hello world!hhh" publicKey:publicKey];
    NSLog(@"encrypted: %@", ret);
    
    NSString *privateKey = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rsa_private_key" ofType:@".pem"] encoding:NSUTF8StringEncoding error:nil];
    NSString *tar = [HTRSA decryptString:ret privateKey:privateKey];
    NSLog(@"decrypted: %@", tar);
    
    NSString *cipherText = [HTRSA rsaEncryptText:@"123"];
    NSLog(@"encrypted: %@",cipherText);
    NSLog(@"decrypted: %@",[HTRSA rsaDecryptText:cipherText]);
    
    NSString *origin = @"abcd";
    NSString *encrypt = [HTAES aesEncryptString:origin withKey:@"123abc"];
    NSLog(@"encrypted: %@", encrypt);
    NSLog(@"decrypted: %@",[HTAES aesDecryptString:encrypt withKey:@"123abc"]);
}

@end
