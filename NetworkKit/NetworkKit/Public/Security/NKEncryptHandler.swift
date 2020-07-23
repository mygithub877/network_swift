//
//  NKEncryptHandler.swift
//  NetworkKit
//
//  Created by wenjie liu on 2020/7/21.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import UIKit
import CommonCrypto
import Security
import SwiftyRSA
let _SEC_RSA_PUB_KEY="MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDUIxB557wF4pLAlCUXb8bkKUl8"+"GdT/abhvav2fQDrXfXc4MKwylRa2w0d0v0V8/Na2aIgD144sjom7ABtsuACM4KZF"+"hyfNtLTYjnkLZ7n7pOManEtjvSxyo0ILYRBRBFEksY0N1rZzLmphXeJoFnxWyDJ1"+"Bf6oxU5LWWDDOqK1xwIDAQAB"
let _SEC_AES_KEY="com.sec.a1.k"
let _SEC_AES_TIME="com.sec.a1.t"

class NKEncryptHandler: NSObject {
    public static var `default`: NKEncryptHandler { NKEncryptHandler() }
    var key:Data?
    var enc_key:Data?
    var iv:Data?
    override init()  {
        super.init()
        let time=UserDefaults.standard.double(forKey: _SEC_AES_TIME);
        var base64Keydata=UserDefaults.standard.object(forKey: _SEC_AES_KEY) as? String
        if Date().timeIntervalSince1970-time > 24*3600 {
            base64Keydata=nil;
        }
        if base64Keydata == nil {
            var bytes = [UInt8](repeating: 0, count: 16)
            let result=SecRandomCopyBytes(kSecRandomDefault, 16, &bytes)
            if result == errSecSuccess {
                key=Data(bytes: bytes, count: 16);
                enc_key=try? rsa_encrypt(data: key!)
                base64Keydata=key?.base64EncodedString()
                UserDefaults.standard.set(base64Keydata, forKey: _SEC_AES_KEY)
                UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: _SEC_AES_TIME)
                UserDefaults.standard.synchronize()
            }else{
                print("Problem generating random bytes")
            }
        } else {
            key=Data(base64Encoded: base64Keydata!)
        }
        var bytes = [UInt8](repeating: 0, count: 16)
        let result=SecRandomCopyBytes(kSecRandomDefault, 16, &bytes)
        if result == errSecSuccess {
            iv=Data(bytes: bytes, count: 16);
        }else{
            print("Problem generating random bytes")
        }
    }
    func updateAESKey() {
        var bytes = [UInt8](repeating: 0, count: 16)
        let result=SecRandomCopyBytes(kSecRandomDefault, 16, &bytes)
        if result == errSecSuccess {
            key=Data(bytes: bytes, count: 16);
            let base64Keydata=key?.base64EncodedString()
            UserDefaults.standard.set(base64Keydata, forKey: _SEC_AES_KEY)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: _SEC_AES_TIME)
            UserDefaults.standard.synchronize()
            enc_key=try? rsa_encrypt(data: key!)
        }else{
            print("Problem generating random bytes")
        }
    }
    func encrypt(httpBody:Data?) -> Data? {
        guard httpBody != nil else {
            return nil;
        }
        
        guard let aesData=aes_encrypt(httpBody: httpBody!) else { return nil }
        let base64Iv=iv!.base64EncodedData()
        var temp=Data()
        temp.append(aesData)
        let dataLength=temp.count
        let keyLength=key!.count
        var keyBytes = [UInt8](repeating: 0, count: key!.count)
        key!.copyBytes(to: &keyBytes, count: key!.count)
        var tmpBytes = [UInt8](repeating: 0, count: temp.count)
        temp.copyBytes(to: &tmpBytes, count: temp.count)
        var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), keyBytes, keyLength, tmpBytes, dataLength, &buffer)
        var output=""
        for i in 0..<Int(CC_SHA256_DIGEST_LENGTH) {
            output.append(String(format: "%02x", buffer[i]))
        }
        let mac=output.data(using: .utf8)
        let base64AESData=aesData.base64EncodedData()
        let dot=".".data(using: .utf8)
        var requestData = Data()
        requestData.append(base64Iv)
        requestData.append(dot!)
        requestData.append(base64AESData)
        requestData.append(dot!)
        requestData.append(mac!)
        let clientid="udid" + ":"
        var clientIdData=clientid.data(using: .utf8)
        clientIdData?.append(requestData.base64EncodedData())
        if enc_key != nil {
            clientIdData?.append(":".data(using: .utf8)!)
            clientIdData?.append(enc_key!.base64EncodedData())
            enc_key=nil
        }
        let rawdata=clientIdData?.base64EncodedData()
        return rawdata;
    }
    
    func aes_encrypt(httpBody:Data) -> Data? {
        guard key != nil && iv != nil else {
            return nil;
        }
        var keyBytes = [UInt8](repeating: 0, count: kCCKeySizeAES256+1)
        key!.copyBytes(to: &keyBytes, count: key!.count)
        var ivBytes = [UInt8](repeating: 0, count: kCCBlockSizeAES128+1)
        iv!.copyBytes(to: &ivBytes, count: iv!.count)
        
        let bufferSize:size_t = httpBody.count + kCCBlockSizeAES128;
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        var numBytesEncrypted:size_t = 0
        var dataBytes=[UInt8](repeating: 0, count: httpBody.count)
        httpBody.copyBytes(to: &dataBytes, count: httpBody.count)
        let status=CCCrypt(CCOperation(kCCEncrypt), CCAlgorithm(kCCAlgorithmAES128), CCOptions(kCCOptionPKCS7Padding), keyBytes, kCCBlockSizeAES128, ivBytes, dataBytes, httpBody.count, &buffer, bufferSize, &numBytesEncrypted)
        if status == kCCSuccess {
            return Data(bytes: buffer, count: numBytesEncrypted)
        }
        return nil;
    }
    func rsa_encrypt(data:Data) throws -> Data {
        let publicKey = try PublicKey(pemNamed: _SEC_RSA_PUB_KEY)
        let clear = ClearMessage(data: data)
        let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
        // Then you can use:
        let data = encrypted.data
        return data;
    }
}
