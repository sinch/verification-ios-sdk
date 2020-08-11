//
//  BaseVerificationMethodConfigBuilder.swift
//  Verification
//
//  Created by Aleksander Wojcik on 16/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Base class for all the verification method configuraiton builders.
///
/// This class acts as simple storage for properties common for every verificaiton method builder.
public class BaseVerificationMethodConfigBuilder {
    
    public var globalConfig: SinchGlobalConfig!
    public var number: String!
    
    public var honourEarlyReject: Bool = true
    public var custom: String?
    public var reference: String?
    public var acceptedLanguages: [VerificationLanguage] = []
    
    public init() {}
}
