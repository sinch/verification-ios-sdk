//
//  AutoConfigBuilderSetters.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

public protocol AutoGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> AutoVerificationNumberSetter
}

public protocol AutoVerificationNumberSetter {
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> AutoVerificationConfigCreator
    func number(_ number: String) -> AutoVerificationConfigCreator
}

public extension AutoVerificationNumberSetter {
    
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> AutoVerificationConfigCreator {
        number(verificationProperties.number)
            .custom(verificationProperties.custom)
            .honourEarlyReject(verificationProperties.honoursEarlyReject)
            .reference(verificationProperties.reference)
            .acceptedLanguages(verificationProperties.acceptedLanguages)
    }
    
}

public protocol AutoVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> AutoVerificationConfig
}
