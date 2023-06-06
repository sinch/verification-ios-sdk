//
//  SeamlessConfigBuilderSetters.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

public protocol SeamlessGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> SeamlessVerificationNumberSetter
}

public protocol SeamlessVerificationNumberSetter {
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> SeamlessVerificationConfigCreator
    func number(_ number: String) -> SeamlessVerificationConfigCreator
    func skipLocalInitialization() -> SeamlessVerificationConfigCreator
}

public extension SeamlessVerificationNumberSetter {
    
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> SeamlessVerificationConfigCreator {
        let creator: SeamlessVerificationConfigCreator
        if let propNumber = verificationProperties.number {
            creator = self.number(propNumber)
        } else {
            creator = self.skipLocalInitialization()
        }
        return creator.custom(verificationProperties.custom)
            .honourEarlyReject(verificationProperties.honoursEarlyReject)
            .reference(verificationProperties.reference)
            .acceptedLanguages(verificationProperties.acceptedLanguages)
    }
    
}

public protocol SeamlessVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> SeamlessVerificationConfig
}
