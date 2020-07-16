//
//  VerificationMethod.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Class containing common logic for every verification method.
///
/// Every specific verification method should inherit from this class.
class VerificationMethod<Router, InitData: InitiationResponseData> {
        
    private let verificationMethodConfig: VerificationMethodConfiguration<Router>
    private let verificationCallbacks: VerificationMethodCallbacks
    private var initiationResponseData: InitData?
        
    var verificationListener: VerificationListener
    
    var verificationState: VerificationState = .idle
        
    var id: String? {
        return initiationResponseData?.id
    }
    
    /// Default initializer
    /// - Parameters:
    ///   - verificationCallbacks: Callbacks to be invoked during the verification process.
    ///   - verificationMethodConfig: Verification method specific configuration reference.
    ///   - verificationListener: Verification listener to be notified about verification process.
    init(
        verificationCallbacks: VerificationMethodCallbacks,
        verificationMethodConfig: VerificationMethodConfiguration<Router>,
        verificationListener: VerificationListener = EmptyVerificationListener()
    ) {
        self.verificationCallbacks = verificationCallbacks
        self.verificationMethodConfig = verificationMethodConfig
        self.verificationListener = verificationListener
    }
    
    private func verify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        if verificationState.canVerify {
            update(newState: .verification(status: .ongoing))
            verificationCallbacks.onVerify(verificationCode, fromSource: sourceType)
        }
    }

}

extension VerificationMethod: Verification {
    
    final func initiate() {
        if verificationCallbacks.onPreInitiate() && verificationState.canInitiate {
            update(newState: .initialization(status: .ongoing))
            verificationCallbacks.onInitiate()
        }
    }
    
    final func verify(verificationCode: String) {
        verify(verificationCode, fromSource: .manual)
    }
    
    func stop() {
        guard !verificationState.isVerificationProcessFinished else { return }
        update(newState: .manuallyStopped)
    }
    
}

extension VerificationMethod: VerificationStateListener {
    
    func update(newState: VerificationState) {
        self.verificationState = newState
    }
    
}
