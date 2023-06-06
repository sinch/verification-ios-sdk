//
//  VerificationMethodConfiguration.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Base class for common configuration of every verification method.
public class VerificationMethodConfiguration: VerificationMethodProperties {
    
    public let number: String?
    public let custom: String?
    public let reference: String?
    public let honoursEarlyReject: Bool
    public let acceptedLanguages: [VerificationLanguage]
    
    let globalConfig: SinchGlobalConfig
    let metadataFactory: PhoneMetadataFactory
    
    init(globalConfig: SinchGlobalConfig, number: String?,
                custom: String? = nil, reference: String? = nil, honoursEarlyReject: Bool = true,
                acceptedLanguages: [VerificationLanguage] = [],
                metadataFactory: PhoneMetadataFactory = IOSMetadataFactory()) {
        self.globalConfig = globalConfig
        self.number = number
        self.metadataFactory = metadataFactory
        self.custom = custom
        self.reference = reference
        self.honoursEarlyReject = honoursEarlyReject
        self.acceptedLanguages = acceptedLanguages
    }
    
}
