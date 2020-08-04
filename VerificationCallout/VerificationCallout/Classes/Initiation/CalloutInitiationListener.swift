//
//  CalloutInitiationListener.swift
//  VerificationCallout
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

public protocol CalloutInitiationListener: InitiationListener {
    func onInitiated(_ data: CalloutInitiationResponseData)
}

public extension CalloutInitiationListener {
    
    func onInitiated(_ data: CalloutInitiationResponseData) { }
    
}
