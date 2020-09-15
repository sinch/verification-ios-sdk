//
//  VerificationApiCallback.swift
//  Verification
//
//  Created by Aleksander Wojcik on 06/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// ApiCallback used by different verification methods that handles verification API call result, makes sure the process has finished successfully and notifies the VerificationListener.
class VerificationApiCallback {
    
    private weak var listener: VerificationListener?
    private weak var verificationStateListener: VerificationStateListener?
    
    private var notYetVerified: Bool {
        guard let verificationStateListener = verificationStateListener else {
            return false
        }
        return !verificationStateListener.verificationState.isVerified &&
            !(verificationStateListener.verificationState == VerificationState.manuallyStopped)
    }
    
    init (listener: VerificationListener?, verificationStateListener: VerificationStateListener?) {
        self.listener = listener
        self.verificationStateListener = verificationStateListener
    }
    
    func handleResponse(_ response: ApiResponse<VerificationResponseData>) {
        guard notYetVerified else { return }
        switch response {
        case .success:
            verificationStateListener?.update(newState: .verification(status: .success))
            listener?.onVerified()
        case .failure(let error):
            verificationStateListener?.update(newState: .verification(status: .error))
            listener?.onVerificationFailed(e: error)
        }
    }
    
}
