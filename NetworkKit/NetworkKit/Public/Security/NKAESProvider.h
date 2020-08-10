//
//  NKAESProvider.h
//  NetworkKit
//
//  Created by wenjie liu on 2019/11/26.
//  Copyright © 2019 iloc.cc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKAESProvider : NSObject
+ (instancetype)defaultProvider;
@property (nonatomic, strong) NSString *udid;//当前设备唯一id

- (nullable NSData *)mof_encryptData:(nullable NSData *)data;

- (nullable NSData *)aes_encrypt:(nullable NSData *)data;
- (nullable NSData *)aes_decrypt:(nullable NSData *)data;

- (void)setNeedUpdateAESKey;
@end
@interface NKRSAProvider : NSObject
+ (nullable NSString *)encryptString:(nullable NSString *)str;
+ (nullable NSData *)encryptData:(nullable NSData *)data;

@end
NS_ASSUME_NONNULL_END
