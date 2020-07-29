//
//  FlashcallConfigBuilderSetters.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 28/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

public protocol FlashcallGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> FlashcallVerificationNumberSetter
}

public protocol FlashcallVerificationNumberSetter {
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> FlashcallVerificationConfigCreator
    func number(_ number: String) -> FlashcallVerificationConfigCreator
}

public extension FlashcallVerificationNumberSetter {
    
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> FlashcallVerificationConfigCreator {
        number(verificationProperties.number)
            .custom(verificationProperties.custom)
            .honourEarlyReject(verificationProperties.honoursEarlyReject)
            .reference(verificationProperties.reference)
            .acceptedLanguages(verificationProperties.acceptedLanguages)
    }
    
}

public protocol FlashcallVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> FlashcallVerificationConfig
}
