//
//  CalloutConfigBuilderSetters.swift
//  Verification
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

public protocol CalloutGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> CalloutVerificationNumberSetter
}

public protocol CalloutVerificationNumberSetter {
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> CalloutVerificationConfigCreator
    func number(_ number: String) -> CalloutVerificationConfigCreator
}

public extension CalloutVerificationNumberSetter {
    
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> CalloutVerificationConfigCreator {
        number(verificationProperties.number ?? "")
            .custom(verificationProperties.custom)
            .honourEarlyReject(verificationProperties.honoursEarlyReject)
            .reference(verificationProperties.reference)
            .acceptedLanguages(verificationProperties.acceptedLanguages)
    }
    
}

public protocol CalloutVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> CalloutVerificationConfig
}
