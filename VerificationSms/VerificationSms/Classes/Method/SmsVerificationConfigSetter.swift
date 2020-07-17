//
//  SmsVerificationConfigSetter.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public protocol SmsVerificationConfigSetter {
    func config(_ config: SmsVerificationConfig) -> SmsVerificationMethodCreator
}
