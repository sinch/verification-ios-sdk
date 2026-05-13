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
            .authorizationMethod(BasicAuthorizationMethod(appKey: "<YOUR APP KEY>", appSecret: "<YOUR APP SECRET>"))
            .build()
    }()
    
    var smsConfiguarion: SmsVerificationConfig {
        return SmsVerificationConfig.Builder.instance()
            .globalConfig(self.globalConfig)
            .number(phoneNumberTextField.text ?? "") //TODO change test number when sample app ready
            .build()
    }

    @IBAction func didTapInitializeButton(_ sender: Any) {
        let verificationDialogController = VerificationDialogController.instantiate()
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

extension VerificationController: VerificationListener {}

extension VerificationController: SmsInitiationListener {
    
    func onInitiated(_ data: SmsInitiationResponseData) {
        print("onInitiated called with \(data)")
    }
    
    func onInitiationFailed(e: Error) {
        print("onInitationFailed with \(e)")
    }
}
