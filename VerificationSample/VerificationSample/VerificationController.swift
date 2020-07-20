//
//  ViewController.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 07/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit
import VerificationSms
import VerificationCore

class VerificationController: UIViewController {
        
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private weak var verificationDialogController: VerificationDialogController?
    private var verification: Verification?
    
    lazy var globalConfig: SinchGlobalConfig = {
        return SinchGlobalConfig.Builder.instance()
            .authorizationMethod(AppKeyAuthorizationMethod(appKey: "9e556452-e462-4006-aab0-8165ca04de66")) //TODO handle appkeys differently
            .build()
    }()
    
    var smsConfiguarion: SmsVerificationConfig {
        return SmsVerificationConfig.Builder.instance()
            .globalConfig(self.globalConfig)
            .number(phoneNumberTextField.text ?? "")
            .build()
    }

    @IBAction func didTapInitializeButton(_ sender: Any) {
        let verificationDialogController = VerificationDialogController.instantiate()
        verificationDialogController.delegate = self
        
        self.verification = buildVerification()
        self.present(verificationDialogController, animated: true, completion: nil)
        self.verification?.initiate()
    }
    
    private func buildVerification() -> Verification {
        return SmsVerificationMethod.Builder.instance()
            .config(self.smsConfiguarion)
            .initiationListener(self)
            .verificationListener(self)
            .build()
    }

}

extension VerificationController: VerificationListener {
    
    func onVerified() {
        print("onVerified called")
    }
    
    func onVerificationFailed(e: Error) {
        print("onVerificationFailed called with \(e)")
    }
    
}

extension VerificationController: SmsInitiationListener {
    
    func onInitiated(_ data: SmsInitiationResponseData) {
        print("onInitiated called with \(data)")
    }
    
    func onInitiationFailed(e: Error) {
        print("onInitationFailed with \(e)")
    }
}

extension VerificationController: VerificationDialogDelegate {
    
    func verificationDialog(_ verificationDialog: VerificationDialogController,
                            didTypeVerificationCode verificationCode: String) {
        print("Delegate passed code \(verificationCode)")
        verification?.verify(verificationCode: verificationCode)
    }
    
}
