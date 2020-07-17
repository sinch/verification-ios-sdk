//
//  SmsVerificationMethod.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore
import Alamofire

/// [Verification](x-source-tag://[Verification]) that uses sms messages to verify user's phone number.
///
/// The code that is received must be manually typed by the user. Use [SmsVerificationMethod.Builder] to create an instance
/// of the verification.
/// - TAG: SmsVerificationMethod
public class SmsVerificationMethod: VerificationMethod<SmsInitiationResponseData> {
    
    private(set) public weak var initiationListener: SmsInitiationListener?
    
    private init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: SmsInitiationListener? = nil,
        verificationListener: VerificationListener? = nil)
    {
        self.initiationListener = initiationListener
        super.init(verificationMethodConfig: verificationMethodConfig, verificationListener: verificationListener)
    }
    
    public override func onInitiate() { }
    
}
