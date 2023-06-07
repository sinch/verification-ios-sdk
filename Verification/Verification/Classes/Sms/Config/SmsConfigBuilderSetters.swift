//
//  SmsGlobalConfigSetter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 16/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public protocol SmsGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> SmsVerificationNumberSetter
}

public protocol SmsVerificationNumberSetter {
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> SmsVerificationConfigCreator
    func number(_ number: String) -> SmsVerificationConfigCreator
}

public extension SmsVerificationNumberSetter {
    
    func withVerificationProperties(_ verificationProperties: VerificationMethodProperties) -> SmsVerificationConfigCreator {
        number(verificationProperties.number ?? "")
            .custom(verificationProperties.custom)
            .honourEarlyReject(verificationProperties.honoursEarlyReject)
            .reference(verificationProperties.reference)
            .acceptedLanguages(verificationProperties.acceptedLanguages)
    }
    
}

public protocol SmsVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> SmsVerificationConfig
}
