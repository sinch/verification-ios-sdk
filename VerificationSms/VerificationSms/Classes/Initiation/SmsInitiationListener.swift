//
//  SmsInitiationListener.swift
//  VerificationSms
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import VerificationCore

public protocol SmsInitiationListener: InitiationListener {
    func onInitiated(_ data: SmsInitiationResponseData)
}

public extension SmsInitiationListener {
    
    func onInitiated(_ data: SmsInitiationResponseData) { }
    
}
