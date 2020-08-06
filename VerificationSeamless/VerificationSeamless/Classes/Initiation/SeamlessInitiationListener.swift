//
//  SeamlessInitiationListener.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

public protocol SeamlessInitiationListener: InitiationListener {
    func onInitiated(_ data: SeamlessInitiationResponseData)
}

public extension SeamlessInitiationListener {
    
    func onInitiated(_ data: SeamlessInitiationResponseData) { }
    
}
