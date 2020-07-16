//
//  NKError.swift
//  NetworkKit
//
//  Created by liuwenjie on 2020/5/31.
//  Copyright © 2020 iloc.cc. All rights reserved.
//

import Foundation
import Alamofire

enum NKError:Equatable {
    case notConnectedToInternet
    case timeout
    case cannotConnectToHost
    case http(statusCode:Int)
    case server(code:Int?,err:String?)
    case other(err:String,detailErr:String?)
    
    var statusCode:Int{
        switch self {
        case let .http(statusCode):
            return statusCode
        default:
            return 0
        }
    }
    var errorDescription:String{
        switch self {
        case let .other(err, _):
            return err;
        case .notConnectedToInternet:
            return "網路連結失敗，請檢查網路"
        case .timeout:
            return "要求逾時，請稍後再試"
        case .cannotConnectToHost:
            return "伺服器無回應，請稍後再試"
        case .http(let statusCode):
            if statusCode >= 500 {
                return "伺服器異常(狀態碼:\(statusCode))"
            }else{
                return "請求異常(狀態碼:\(statusCode))"
            }
        case let .server(_, err):
            return err ?? ""
        }
    
    }
    var errorDetailDescription:String?{
        switch self {
        case let .other(_, detailErr):
            return detailErr
        default:
            return nil;
        }
    }
    var isNetworkError:Bool{
        if self == .notConnectedToInternet {
            return true
        }else{
            return false
        }
    }
    var isHTTPError:Bool{
        switch self {
        case .http(_):
            return true
        default:
            return false
        }
    }
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs,rhs) {
        case (.notConnectedToInternet,.notConnectedToInternet):
            return true;
        case (.timeout,.timeout):
            return true;
        case (.cannotConnectToHost,.cannotConnectToHost):
            return true;
        case (.other,.other):
            return true;
        case (.http,.http):
            return true;
        case (.server,.server):
            return true;
        default:
            return false
        }
    }
    init(err:AFError?) {
        if err == nil {
            self = .other(err: "未知的錯誤",detailErr:nil)
            return
        }
        var errDescription:String?
        var aError:NSError?
        switch err! {
        case .explicitlyCancelled:
            errDescription = "請求被取消"
        case .invalidURL(_):
            errDescription = "無效的URL"
        case .parameterEncodingFailed(_):
            errDescription = "參數編碼失敗"
        case .parameterEncoderFailed(_):
            errDescription = "參數編碼失敗"
        case .multipartEncodingFailed(_):
            errDescription = "請求體編碼失敗"
        case .requestAdaptationFailed(_):
            errDescription = "請求發起失敗"
        case .responseValidationFailed(_):
            errDescription = "數據驗證失敗"
        case .responseSerializationFailed(_):
            errDescription = "數據序列化失敗"
        case .requestRetryFailed(_, _):
            errDescription = "請求重試失敗"
        case .sessionDeinitialized:
            errDescription = "請求會話已被銷毀"
        case .sessionInvalidated(_):
            errDescription = "請求會話無效"
        case .serverTrustEvaluationFailed(_):
            errDescription = "安全認證失敗"
        case .urlRequestValidationFailed(_):
            errDescription = "請求校驗失敗"
        case .createUploadableFailed(_):
            errDescription = "上傳發起失敗"
        case .createURLRequestFailed(_):
            errDescription = "上傳發起失敗"
        case .downloadedFileMoveFailed(_, _, _):
            errDescription = "下載失敗"
        case let .sessionTaskFailed(error):
            errDescription = nil
            aError=error as NSError
        }
        if aError == nil {
            self = .other(err:errDescription ?? "請求失敗",detailErr:err?.errorDescription)
        }else{
            if aError!.code == NSURLErrorNetworkConnectionLost || aError!.code == NSURLErrorNotConnectedToInternet {
                self = .notConnectedToInternet
            }else if aError!.code == NSURLErrorTimedOut{
                self = .timeout
            }else if aError!.code == NSURLErrorCannotConnectToHost{
                self = .cannotConnectToHost
            }else{
                self = .other(err: "", detailErr: "")
            }
        }
    }
    
}
