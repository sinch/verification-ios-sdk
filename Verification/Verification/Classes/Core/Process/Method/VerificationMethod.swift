//
//  VerificationMethod.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Alamofire
import CocoaLumberjack

/// Class containing common logic for every verification method.
///
/// Every specific verification method should inherit from this class.
public class VerificationMethod: VerificationMethodCallbacks, InitiationListener, VerificationListener {
        
    let verificationMethodConfig: VerificationMethodConfiguration
    var initiationResponseData: InitiationResponseData?

    private(set) weak var initiationListener: InitiationListener?
    private(set) weak var verificationListener: VerificationListener?

    private(set) public var verificationState: VerificationState = .idle
    
    private lazy var interceptionTimeoutReachedDispatchItem = DispatchWorkItem { [weak self] in
        self?.update(newState: .verification(status: .error))
        self?.verificationListener?.onVerificationFailed(e: SDKError.timeoutException)
    }
        
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
    
    private func verify(_ verificationCode: String, fromSource sourceType: VerificationSourceType, usingMethod method: VerificationMethodType?) {
        if verificationState.canVerify {
            update(newState: .verification(status: .ongoing))
            DDLogDebug("Verification trying to verify code \(verificationCode) fromSource: \(sourceType) with \(String(describing: method))")
            onVerify(verificationCode, fromSource: sourceType, usingMethod: method)
        }
    }
    
    func onPreInitiate() -> Bool {
        return true
    }
    
    func report() {}
    
    func onInitiate() { }
    
    func onVerify(_ verificationCode: String, fromSource sourceType: VerificationSourceType, usingMethod method: VerificationMethodType?) { }
    
    public func onInitiated(_ data: InitiationResponseData) {
        self.initiationResponseData = data
        self.initiationListener?.onInitiated(data)
        self.initializeInterceptionTimeoutCallback()
    }
    
    public func onInitiationFailed(e: Error) {
        self.initiationListener?.onInitiationFailed(e: e)
    }
    
    public func onVerified() {
        DDLogDebug("Verification successfull")
        self.cancelInterceptionTimeoutCallback()
        self.verificationListener?.onVerified()
    }
    
    public func onVerificationFailed(e: Error) {
        DDLogDebug("Verificaiton failed with error: \(e.localizedDescription)")
        self.verificationListener?.onVerificationFailed(e: e)
    }
    
    private func initializeInterceptionTimeoutCallback() {
        guard let interceptionTimeoutDate = initiationResponseData?.initiationDataTimeoutDate else { return }
        let dispatchTimeInterval = interceptionTimeoutDate.timeIntervalSinceNow
        DispatchQueue.main.asyncAfter(
            deadline: .now() + dispatchTimeInterval,
            execute: interceptionTimeoutReachedDispatchItem
        )
    }
    
    private func cancelInterceptionTimeoutCallback() {
        interceptionTimeoutReachedDispatchItem.cancel()
    }
    
}

extension VerificationMethod: Verification {
    
    final public func initiate() {
        if onPreInitiate() && verificationState.canInitiate {
            update(newState: .initialization(status: .ongoing))
            onInitiate()
        }
    }
    
    final public func verify(verificationCode: String, method: VerificationMethodType?) {
        verify(verificationCode, fromSource: .manual, usingMethod: method)
    }
    
    public func stop() {
        cancelInterceptionTimeoutCallback()
        guard !verificationState.isVerificationProcessFinished else { return }
        update(newState: .manuallyStopped)
    }
    
}

extension VerificationMethod: VerificationStateListener {
    
    func update(newState: VerificationState) {
        self.verificationState = newState
    }
    
}
