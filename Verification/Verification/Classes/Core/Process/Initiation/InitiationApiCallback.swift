//
//  InitiationApiCallback.swift
//  Verification
//
//  Created by Aleksander Wojcik on 06/08/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

class InitiationApiCallback {
    
    private weak var verificationStateListener: VerificationStateListener?
    private weak var initiationListener: InitiationListener?
        
    private var notManuallyStopped: Bool {
        guard let verificationStateListener = verificationStateListener else {
            return false
        }
        return verificationStateListener.verificationState != .manuallyStopped
    }
    
    init(verificationStateListener: VerificationStateListener?,
                 initiationListener: InitiationListener?) {
        self.verificationStateListener = verificationStateListener
        self.initiationListener = initiationListener
    }
    
    func handleResponse(_ response: ApiResponse<InitiationResponseData>) {
        guard notManuallyStopped else { return }
        switch response {
        case .success(let data, let headers):
            verificationStateListener?.update(newState: .initialization(status: .success))
            let contentLanguageHeader = headers["Content-Language"]
            let dateHeader = headers["Date"]
            let modifiedData = data.withHeadersData(
                contentLanguage: contentLanguageHeader.asContentLanguage(),
                dateOfGeneration: dateHeader.asGenerationDate()
            )
            initiationListener?.onInitiated(modifiedData)
        case .failure(let error):
            verificationStateListener?.update(newState: .initialization(status: .error))
            initiationListener?.onInitiationFailed(e: error)
        }
    }
}

fileprivate extension Optional where Wrapped == String {
    
    func asContentLanguage() -> VerificationLanguage? {
        if let contentLanguage = self {
            return VerificationLanguage(contentLanguageHeader: contentLanguage)
        } else {
            return nil
        }
    }
    
    func asGenerationDate() -> Date {
        if let generationDate = self {
            let formatter = DateFormatter().apply {
                $0.dateFormat = "E, dd MMM y HH:mm:ss zzz"
            }
            return formatter.date(from: generationDate) ?? Date()
        } else {
            return Date()
        }
    }
    
}
