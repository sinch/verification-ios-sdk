//
//  SmsGlobalConfigSetter.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 16/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//
import VerificationCore

public protocol SmsGlobalConfigSetter {
    func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> SmsVerificationNumberSetter
}

public protocol SmsVerificationNumberSetter {
    func number(_ number: String) -> SmsVerificationConfigCreator
}

public protocol SmsVerificationConfigCreator: VerificationMethodConfigCreatorParameters {
    func build() -> SmsVerificationConfig
}
