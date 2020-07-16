//
//  VerificationStateListener.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

protocol VerificationStateListener {
    
    var verificationState: VerificationState { get }
    
    func update(newState: VerificationState)
    
}
