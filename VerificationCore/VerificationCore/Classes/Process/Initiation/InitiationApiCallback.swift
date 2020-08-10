//
//  InitiationApiCallback.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 06/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public class InitiationApiCallback {
    
    private weak var verificationStateListener: VerificationStateListener?
    private weak var initiationListener: InitiationListener?
        
    private var notManuallyStopped: Bool {
        guard let verificationStateListener = verificationStateListener else {
            return false
        }
        return verificationStateListener.verificationState != .manuallyStopped
    }
    
    public init (verificationStateListener: VerificationStateListener?,
                 initiationListener: InitiationListener?) {
        self.verificationStateListener = verificationStateListener
        self.initiationListener = initiationListener
    }
    
    internal func handleResponse(_ response: ApiResponse<InitiationResponseData>) {
        guard notManuallyStopped else { return }
        switch response {
        case .success(let data, let headers):
            verificationStateListener?.update(newState: .initialization(status: .success))
            let modifiedData: InitiationResponseData
            if let contentLanguageHeader = headers["Content-Language"] {
                modifiedData = data.withContentLanguage(VerificationLanguage(contentLanguageHeader: contentLanguageHeader))
            } else {
                modifiedData = data
            }
            initiationListener?.onInitiated(modifiedData)
        case .failure(let error):
            verificationStateListener?.update(newState: .initialization(status: .error))
            initiationListener?.onInitiationFailed(e: error)
        }
    }
}
