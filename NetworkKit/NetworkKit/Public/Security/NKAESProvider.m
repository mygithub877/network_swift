//
//  NKAESProvider.m
//  NetworkKit
//
//  Created by wenjie liu on 2019/11/26.
//  Copyright © 2019 iloc.cc. All rights reserved.
//

#import "NKAESProvider.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <Security/Security.h>
#import <NetworkKit/NetworkKit-Swift.h>

#define _SEC_RSA_PUB_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUIxB557wF4pLAlCUXb8bkKUl8""GdT/abhvav2fQDrXfXc4MKwylRa2w0d0v0V8/Na2aIgD144sjom7ABtsuACM4KZF""hyfNtLTYjnkLZ7n7pOManEtjvSxyo0ILYRBRBFEksY0N1rZzLmphXeJoFnxWyDJ1""Bf6oxU5LWWDDOqK1xwIDAQAB"


#define _SEC_AES_KEY @"com.sec.a1.k"
#define _SEC_AES_TIME  @"com.sec.a1.t"

//static NSString *base64_encode(NSString *str){
//    NSString *ret = [[str dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
//    return ret;
//}
static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}
@implementation NKAESProvider{
    NSData *_key;
    NSData *_enc_key;
    NSData *_iv;
}
+ (instancetype)defaultProvider{
    static NKAESProvider *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=NKAESProvider.alloc.init;
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSTimeInterval time=[NSUserDefaults.standardUserDefaults doubleForKey:_SEC_AES_TIME];
        NSString *base64Keydata=[[NSUserDefaults standardUserDefaults] objectForKey:_SEC_AES_KEY];
        
        if (NSDate.date.timeIntervalSince1970-time>24*3600) {
            base64Keydata=nil;
        }
        uint8_t randomBytes1[16];
        int result1=SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes1);
        NSLog(@"%d",result1);
//        NSData *tdata=[NKRSAProvider encryptData:[@"data" dataUsingEncoding:NSUTF8StringEncoding]];
        if (!base64Keydata) {
            _key=[NSData dataWithBytes:randomBytes1 length:16];
            _enc_key=[NKRSAProvider encryptData:_key];
            base64Keydata=[_key base64EncodedStringWithOptions:0];
            [[NSUserDefaults standardUserDefaults] setObject:base64Keydata forKey:_SEC_AES_KEY];
            [[NSUserDefaults standardUserDefaults] setDouble:NSDate.date.timeIntervalSince1970 forKey:_SEC_AES_TIME];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            _key=[[NSData alloc] initWithBase64EncodedString:base64Keydata options:0];
        }
        uint8_t randomBytes2[16];
        int result2=SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes2);
        NSLog(@"%d",result2);
        _iv=[NSData dataWithBytes:randomBytes2 length:16];
       
        
    }
    return self;
}
- (void)setNeedUpdateAESKey{
    uint8_t randomBytes1[16];
    int result1=SecRandomCopyBytes(kSecRandomDefault, 16, randomBytes1);
    NSLog(@"%d",result1);
    _key=[NSData dataWithBytes:randomBytes1 length:16];
    NSString *base64Keydata=[_key base64EncodedStringWithOptions:0];
    [[NSUserDefaults standardUserDefaults] setObject:base64Keydata forKey:_SEC_AES_KEY];
    [[NSUserDefaults standardUserDefaults] setDouble:NSDate.date.timeIntervalSince1970 forKey:_SEC_AES_TIME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _enc_key=[NKRSAProvider encryptData:_key];
}
- (NSData *)mof_encryptData:(NSData *)data{
    if (data==nil) {
        return nil;
    }
    NSData *aesData=[self aes_encrypt:data];
    NSData *base64Iv=[_iv base64EncodedDataWithOptions:0];
    NSMutableData *temp=[NSMutableData dataWithData:base64Iv];
    [temp appendData:aesData];
//    [temp appendData:_key];
    size_t dataLength = temp.length;
    size_t keyLength = _key.length;
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
        
    CCHmac(kCCHmacAlgSHA256, _key.bytes, keyLength, temp.bytes, dataLength, result);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", result[i]];
    }
    NSData *mac=[output dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *base64AESData=[aesData base64EncodedDataWithOptions:0];
    NSData *dot=[@"." dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData *requestData=[NSMutableData dataWithData:base64Iv];
    [requestData appendData:dot];
    [requestData appendData:base64AESData];
    [requestData appendData:dot];
    [requestData appendData:mac];
    NSString *clientid=[@"udid" stringByAppendingFormat:@":"];
    NSMutableData *clientIdData=[clientid dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [clientIdData appendData:[requestData base64EncodedDataWithOptions:0]];
    if (_enc_key) {
        [clientIdData appendData:[@":" dataUsingEncoding:NSUTF8StringEncoding]];
        [clientIdData appendData:[_enc_key base64EncodedDataWithOptions:0]];
        _enc_key=nil;
    }
    NSData *rawdata=[clientIdData base64EncodedDataWithOptions:0];
    return rawdata;
}

- (NSData *)aes_encrypt:(NSData *)data{
    if (data==nil) {
       return nil;
    }
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [_key getBytes:keyPtr length:_key.length];
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [_iv getBytes:ivPtr length:_iv.length];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if(status == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        NSLog(@"Error");
    }
    free(buffer);
    return nil;
}
- (NSData *)aes_decrypt:(NSData *)data{
    if (data==nil) {
       return nil;
    }
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    [_key getBytes:keyPtr length:_key.length];
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [_iv getBytes:ivPtr length:_iv.length];

    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr, kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if(status == kCCSuccess) {
        NSLog(@"Success");
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    } else {
        NSLog(@"Error");
    }
    free(buffer);
    return nil;
}



@end
@implementation NKRSAProvider
+ (NSString *)encryptString:(NSString *)str{
    return [self encryptString:str publicKey:_SEC_RSA_PUB_KEY];
}

//使用公钥字符串加密
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey
{
    NSData *data = [self encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    NSString *ret = base64_encode_data(data);
    return ret;
}
+ (NSData *)encryptData:(NSData *)data{
    return [self encryptData:data publicKey:_SEC_RSA_PUB_KEY];
}
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey
{
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [self addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    return [self encryptData:data withKeyRef:keyRef];
}
+ (SecKeyRef)addPublicKey:(NSString *)key
{
    NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
    NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
    if(spos.location != NSNotFound && epos.location != NSNotFound){
        NSUInteger s = spos.location + spos.length;
        NSUInteger e = epos.location;
        NSRange range = NSMakeRange(s, e-s);
        key = [key substringWithRange:range];
    }
    key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];

    // This will be base64 encoded, decode it.
    NSData *data = base64_decode(key);
    data = [self stripPublicKeyHeader:data];
    if(!data){
        return nil;
    }

    //a tag to read/write keychain storage
    NSString *tag = @"RSAUtil_PubKey";
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];

    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);

    // Add persistent version of the key to system keychain
    [publicKey setObject:data forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];

    CFTypeRef persistKey = nil;
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil){
        CFRelease(persistKey);
    }
    if ((status != noErr) && (status != errSecDuplicateItem)) {
        return nil;
    }

    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
    if(status != noErr){
        return nil;
    }
    return keyRef;
}
+ (NSData *)stripPublicKeyHeader:(NSData *)d_key
{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);

    unsigned long len = [d_key length];
    if (!len) return(nil);

    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx     = 0;

    if (c_key[idx++] != 0x30) return(nil);

    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;

    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);

    idx += 15;

    if (c_key[idx++] != 0x03) return(nil);

    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;

    if (c_key[idx++] != '\0') return(nil);

    // Now make a new NSData from this buffer
    return ([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}
+ (NSData *)encryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef
{
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;

    size_t block_size = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    void *outbuf = malloc(block_size);
    size_t src_block_size = block_size - 11;

    NSMutableData *ret = [[NSMutableData alloc] init];
    for(int idx=0; idx<srclen; idx+=src_block_size){
        //NSLog(@"%d/%d block_size: %d", idx, (int)srclen, (int)block_size);
        size_t data_len = srclen - idx;
        if(data_len > src_block_size){
            data_len = src_block_size;
        }
    
        size_t outlen = block_size;
        OSStatus status = noErr;
        status = SecKeyEncrypt(keyRef,
                               kSecPaddingPKCS1,
                               srcbuf + idx,
                               data_len,
                               outbuf,
                               &outlen
                               );
        if (status != 0) {
            NSLog(@"SecKeyEncrypt fail. Error Code: %d", status);
            ret = nil;
            break;
        }else{
            [ret appendBytes:outbuf length:outlen];
        }
      }

      free(outbuf);
      CFRelease(keyRef);
      return ret;
  }



@end
