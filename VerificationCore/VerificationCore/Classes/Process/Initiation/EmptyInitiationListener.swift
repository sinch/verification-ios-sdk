//
//  EmptyInitiationListener.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Convenient [InitiationListener](x-source-tag://[InitiationListener])  with empty method implementations.
class EmptyInitiationListener<T: InitiationResponseData>: InitiationListener {
    
    func onInitiated(_ data: InitiationResponseData) { }
    
    func onInitiationFailed(e: Error) { }
    
}
