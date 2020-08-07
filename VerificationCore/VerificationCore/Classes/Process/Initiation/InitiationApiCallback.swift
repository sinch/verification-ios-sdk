//
//  InitiationApiCallback.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 06/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public class InitiationApiCallback<Data: InitiationResponseData> {
    
    private weak var verificationStateListener: VerificationStateListener?
    
    private var resultCallback: (ApiResponse<Data>) -> Void
    
    private var notManuallyStopped: Bool {
        guard let verificationStateListener = verificationStateListener else {
            return false
        }
        return verificationStateListener.verificationState != .manuallyStopped
    }
    
    public init (verificationStateListener: VerificationStateListener?,
                 resultCallback: @escaping (ApiResponse<Data>) -> Void) {
        self.verificationStateListener = verificationStateListener
        self.resultCallback = resultCallback
    }
    
    internal func handleResponse(_ response: ApiResponse<Data>) {
        guard notManuallyStopped else { return }
        switch response {
        case .success:
            verificationStateListener?.update(newState: .initialization(status: .success))
        case .failure:
            verificationStateListener?.update(newState: .initialization(status: .error))
        }
        resultCallback(response)
    }
}
