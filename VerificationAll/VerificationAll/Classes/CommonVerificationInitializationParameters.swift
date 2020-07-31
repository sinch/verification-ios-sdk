//
//  CommonVerificationInitializationParameters.swift
//  VerificationAll
//
//  Created by Aleksander Wojcik on 31/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

/// Container for all the properties needed to initialize any type of verification. Used by ... to create a verification instance based on 'usedMethod' field.
/// - TAG: CommonVerificationInitializationParameters
public struct CommonVerificationInitializationParameters {
    
    let globalConfig: SinchGlobalConfig
    let verificationInitData: VerificationInitData
    let initiationListener: CommonVerificationMethodsInitiationListener?
    let verificationListener: VerificationListener?
    
    public init(globalConfig: SinchGlobalConfig, verificationInitData: VerificationInitData,
         initalizationListener: CommonVerificationMethodsInitiationListener? = nil, verificationListener: VerificationListener? = nil) {
        self.globalConfig = globalConfig
        self.verificationInitData = verificationInitData
        self.initiationListener = initalizationListener
        self.verificationListener = verificationListener
    }
}
