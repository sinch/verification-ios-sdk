//
//  VerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire

/// Class containing common logic for every verification method.
///
/// Every specific verification method should inherit from this class.
public class VerificationMethod: VerificationMethodCallbacks {
        
    let verificationMethodConfig: VerificationMethodConfiguration
    private var initiationResponseData: InitiationResponseData?

    private(set) weak var initiationListener: InitiationListener?
    private(set) weak var verificationListener: VerificationListener?

    private(set) public var verificationState: VerificationState = .idle
        
    var id: String? {
        return initiationResponseData?.id
    }
    
    public var service: Session {
        return verificationMethodConfig.globalConfig.apiManager.session
    }
    
    /// Default initializer
    /// - Parameters:
    ///   - verificationMethodConfig: Verification method specific configuration reference.
    ///   - verificationListener: Verification listener to be notified about verification process.
    init(
        verificationMethodConfig: VerificationMethodConfiguration,
        initiationListener: InitiationListener? = nil,
        verificationListener: VerificationListener? = nil
    ) {
        self.verificationMethodConfig = verificationMethodConfig
        self.initiationListener = initiationListener
        self.verificationListener = verificationListener
    }
    
    private func verify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        if verificationState.canVerify {
            update(newState: .verification(status: .ongoing))
            onVerify(verificationCode, fromSource: sourceType)
        }
    }
    
    func onPreInitiate() -> Bool {
        return true
    }
    
    func report() {}
    
    func onInitiate() { }
    
    func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) { }
    
}

extension VerificationMethod: Verification {
    
    final public func initiate() {
        if onPreInitiate() && verificationState.canInitiate {
            update(newState: .initialization(status: .ongoing))
            onInitiate()
        }
    }
    
    final public func verify(verificationCode: String) {
        verify(verificationCode, fromSource: .manual)
    }
    
    public func stop() {
        guard !verificationState.isVerificationProcessFinished else { return }
        update(newState: .manuallyStopped)
    }
    
}

extension VerificationMethod: VerificationStateListener {
    
    func update(newState: VerificationState) {
        self.verificationState = newState
    }
    
}
