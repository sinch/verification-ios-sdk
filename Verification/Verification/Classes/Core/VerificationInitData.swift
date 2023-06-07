//
//  VerificationInitData.swift
//  Verification
//
//  Created by Aleksander Wojcik on 30/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

/// Helper struct that simplifies creation of verification method configurations with common parameters.
public struct VerificationInitData: VerificationMethodProperties {
    
    public let usedMethod: VerificationMethodType
    public let number: String?
    public let custom: String?
    public let reference: String?
    public let honoursEarlyReject: Bool
    public let acceptedLanguages: [VerificationLanguage]
    
    public init(usedMethod: VerificationMethodType, number: String, custom: String?, reference: String?, honoursEarlyReject: Bool, acceptedLanguages: [VerificationLanguage]){
        self.usedMethod = usedMethod
        self.number = number
        self.custom = custom
        self.reference = reference
        self.honoursEarlyReject = honoursEarlyReject
        self.acceptedLanguages = acceptedLanguages
    }
}
