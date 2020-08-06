//
//  VerificationMethod.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire
import MetadataCollector

/// Class containing common logic for every verification method.
///
/// Every specific verification method should inherit from this class.
open class VerificationMethod<InitData: InitiationResponseData>: VerificationMethodCallbacks {
        
    public let verificationMethodConfig: VerificationMethodConfiguration
    private var initiationResponseData: InitData?
        
    private(set) public weak var verificationListener: VerificationListener?
    
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
    public init(
        verificationMethodConfig: VerificationMethodConfiguration,
        verificationListener: VerificationListener? = nil
    ) {
        self.verificationMethodConfig = verificationMethodConfig
        self.verificationListener = verificationListener
    }
    
    private func verify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) {
        if verificationState.canVerify {
            update(newState: .verification(status: .ongoing))
            onVerify(verificationCode, fromSource: sourceType)
        }
    }
    
    open func onPreInitiate() -> Bool {
        return true
    }
    
    open func report() {}
    
    open func onInitiate() { }
    
    open func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType) { }
    
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
    
    public func update(newState: VerificationState) {
        self.verificationState = newState
    }
    
}
