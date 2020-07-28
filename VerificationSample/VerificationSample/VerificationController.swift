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
import VerificationFlashcall

class VerificationController: UIViewController {
        
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var flashcallButton: UIButton!
    @IBOutlet weak var calloutButton: UIButton!
    @IBOutlet weak var seamlessButton: UIButton!
    
    @IBOutlet weak var customField: UITextField!
    @IBOutlet weak var referenceField: UITextField!
    @IBOutlet weak var acceptedLanguagesField: UITextField!
    @IBOutlet weak var honoursEarlyRejectField: UISwitch!
    
    private var methodButtons: [UIButton] {
        return [smsButton, flashcallButton, calloutButton, seamlessButton]
    }
    
    private weak var verificationDialogController: VerificationDialogController?
    private var verification: Verification?
    
    lazy var globalConfig: SinchGlobalConfig = {
        return SinchGlobalConfig.Builder.instance()
            .authorizationMethod(AppKeyAuthorizationMethod(appKey: "9e556452-e462-4006-aab0-8165ca04de66")) //TODO handle appkeys differently
            .build()
    }()
    
    var smsConfiguarion: SmsVerificationConfig {
        let acceptedLanguages: [VerificationLanguage]
        do {
            acceptedLanguages = try acceptedLanguagesField.text?.nilIfEmpty()?.toLocaleList() ?? []
        } catch {
            acceptedLanguages = []
        }
        return SmsVerificationConfig.Builder.instance()
            .globalConfig(self.globalConfig)
            .number(phoneNumberTextField.text ?? "")
            .custom(customField.text?.nilIfEmpty())
            .reference(referenceField.text?.nilIfEmpty())
            .honourEarlyReject(honoursEarlyRejectField.isOn)
            .acceptedLanguages(acceptedLanguages)
            .build()
    }
    
    var flashcallConfiguarion: FlashcallVerificationConfig {
        return FlashcallVerificationConfig.Builder.instance()
            .globalConfig(self.globalConfig)
            .number(phoneNumberTextField.text ?? "")
            .custom(customField.text?.nilIfEmpty())
            .reference(referenceField.text?.nilIfEmpty())
            .honourEarlyReject(honoursEarlyRejectField.isOn)
            .build()
    }

    @IBAction func didTapInitializeButton(_ sender: Any) {
        let verificationDialogController = VerificationDialogController.instantiate()
        verificationDialogController.delegate = self
        
        self.verificationDialogController = verificationDialogController
        self.verification = buildVerification()
        self.present(verificationDialogController, animated: true, completion: nil)
        self.verification?.initiate()
    }
    
    @IBAction func didTapMethodButton(_ sender: UIButton) {
        guard !sender.isSelected else { return }
        methodButtons.forEach {
            $0.isSelected = ($0 == sender)
        }
    }
    
    private func buildVerification() -> Verification {
        return FlashcallVerificationMethod.Builder.instance()
            .config(self.flashcallConfiguarion)
            .initiationListener(self)
            .verificationListener(self)
            .build()
    }

}

extension VerificationController: VerificationListener {
    
    func onVerified() {
        verificationDialogController?.showVerifiedMessage()
    }
    
    func onVerificationFailed(e: Error) {
        verificationDialogController?.showError(withMessage: e.localizedDescription)
    }
    
}

extension VerificationController: FlashcallInitiationListener, SmsInitiationListener {
    
    func onInitiated(_ data: SmsInitiationResponseData) {
        print("onInitiated called with \(data)")
    }
    
    func onInitiated(_ data: FlashcallInitiationResponseData) {
        print("onInitiated called with \(data)")
    }
    
    func onInitiationFailed(e: Error) {
        verificationDialogController?.showError(withMessage: e.localizedDescription)
        print("onInitationFailed with \(e)")
    }
    
}

extension VerificationController: VerificationDialogDelegate {
    
    func verificationDialogCancelPressed(_ verificationDialog: VerificationDialogController) {
        verification?.stop()
        verificationDialog.dismiss(animated: true, completion: nil)
    }
    
    func verificationDialog(_ verificationDialog: VerificationDialogController,
                            didTypeVerificationCode verificationCode: String) {
        print("Delegate passed code \(verificationCode)")
        verification?.verify(verificationCode: verificationCode)
    }
    
}

fileprivate extension String {
    
    func toLocaleList() throws -> [VerificationLanguage] {
        return try self.split(separator: ",")
            .filter { $0.contains("-") }
            .map { $0.split(separator: "-") }
            .map { substring in
                try VerificationLanguage(language: String(substring[0]), region: String(substring[1]))
            }
    }
}
