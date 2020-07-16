//
//  VerificationMethodConfiguration.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Base class for common configuration of every verification method.
class VerificationMethodConfiguration<Router>: VerificationMethodProperties {
    
    let router: Router
    let globalConfig: SinchGlobalConfig
    let number: String
    let custom: String?
    let reference: String?
    let honoursEarlyReject: Bool
    let acceptedLanguages: [VerificationLanguage]
    
    init(router: Router, globalConfig: SinchGlobalConfig, number: String,
         custom: String? = nil, reference: String? = nil, honoursEarlyReject: Bool = true,
         acceptedLanguages: [VerificationLanguage] = []) {
        self.router = router
        self.globalConfig = globalConfig
        self.number = number
        self.custom = custom
        self.reference = reference
        self.honoursEarlyReject = honoursEarlyReject
        self.acceptedLanguages = acceptedLanguages
    }
    
}
