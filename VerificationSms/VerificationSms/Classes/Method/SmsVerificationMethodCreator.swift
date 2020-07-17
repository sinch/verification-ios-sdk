//
//  SmsVerificationMethodCreator.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 17/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore

///Interface defining requirements of builder that can create SMS Verification Method instances.
public protocol SmsVerificationMethodCreator {
    
    func initiationListener(_ initiationListener: SmsInitiationListener?) -> SmsVerificationMethodCreator
    
    func verificationListener(_ verificationListener: VerificationListener?) -> SmsVerificationMethodCreator
    
    func build() -> Verification
}
