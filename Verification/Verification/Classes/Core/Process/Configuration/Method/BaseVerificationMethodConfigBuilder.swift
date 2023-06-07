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
public class BaseVerificationMethodConfigBuilder: VerificationMethodConfigCreatorParameters {
    
    var globalConfig: SinchGlobalConfig!
    var number: String?
    
    private(set) var honourEarlyReject: Bool = true
    private(set) var custom: String?
    private(set) var reference: String?
    private(set) var acceptedLanguages: [VerificationLanguage] = []
    
    init() {}
    
    public func honourEarlyReject(_ honourEarlyReject: Bool) -> Self {
        return self.apply { $0.honourEarlyReject = honourEarlyReject }
    }
    
    public func custom(_ custom: String?) -> Self {
        return self.apply { $0.custom = custom }
    }
    
    public func reference(_ reference: String?) -> Self {
        return self.apply { $0.reference = reference }
    }
    
    public func acceptedLanguages(_ acceptedLanguages: [VerificationLanguage]) -> Self {
        return self.apply { $0.acceptedLanguages = acceptedLanguages }
    }
    
}

extension BaseVerificationMethodConfigBuilder: HasApply {}
