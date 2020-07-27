//
//  VerificationMethodConfiguration.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import MetadataCollector

/// Base class for common configuration of every verification method.
open class VerificationMethodConfiguration: VerificationMethodProperties {
    
    public let globalConfig: SinchGlobalConfig
    public let number: String
    public let custom: String?
    public let reference: String?
    public let honoursEarlyReject: Bool
    public let acceptedLanguages: [VerificationLanguage]
    public let metadataFactory: PhoneMetadataFactory
    
    public init(globalConfig: SinchGlobalConfig, number: String,
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
