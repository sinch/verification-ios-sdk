//
//  EmptyVerificationListener.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Convenient [VerificationListener](x-source-tag://[VerificationListener]) with empty method implementations.
class EmptyVerificationListener: VerificationListener {
    
    func onVerified() { }
    
    func onVerificationFailed(e: Error) { }
    
}
