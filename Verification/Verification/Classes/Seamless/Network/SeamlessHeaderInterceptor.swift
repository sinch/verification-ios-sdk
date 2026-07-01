//
//  SeamlessHeaderInterceptor.swift
//  Verification
//
//  Copyright © 2026 Sinch. All rights reserved.
//

import Foundation

/// Builds debug-only headers for seamless cellular verification requests to Indian endpoints.
internal struct SeamlessHeaderInterceptor {
    
    static let headerMsisdn = "x-msisdn"
    static let headerImsi = "x-imsi"
    
    private let phoneNumber: String?
    
    init(number: String?) {
        self.phoneNumber = number
    }
    
    func headers() -> [String: String] {
        #if DEBUG
        return debugHeadersForIndianNumber()
        #else
        return [:]
        #endif
    }
    
    #if DEBUG
    private func debugHeadersForIndianNumber() -> [String: String] {
        guard let phoneNumber = phoneNumber,
              SinchPhoneNumberUtils.isIndianNumber(phoneNumber) else {
            return [:]
        }
        
        var headers: [String: String] = [:]
        if let msisdn = Constants.Api.Seamless.debugMsisdn {
            headers[Self.headerMsisdn] = msisdn
        }
        if let imsi = Constants.Api.Seamless.debugImsi {
            headers[Self.headerImsi] = imsi
        }
        return headers
    }
    #endif
}
