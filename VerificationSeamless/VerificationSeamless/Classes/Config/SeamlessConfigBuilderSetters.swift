//
//  SeamlessConfigBuilderSetters.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

public protocol SeamlessGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> SeamlessVerificationNumberSetter
}

public protocol SeamlessVerificationNumberSetter {
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> SeamlessVerificationConfigCreator
    func number(_ number: String) -> SeamlessVerificationConfigCreator
}

public extension SeamlessVerificationNumberSetter {
    
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> SeamlessVerificationConfigCreator {
        number(verificationProperties.number)
            .custom(verificationProperties.custom)
            .honourEarlyReject(verificationProperties.honoursEarlyReject)
            .reference(verificationProperties.reference)
            .acceptedLanguages(verificationProperties.acceptedLanguages)
    }
    
}

public protocol SeamlessVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> SeamlessVerificationConfig
}
