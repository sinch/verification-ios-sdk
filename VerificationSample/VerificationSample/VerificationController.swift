//
//  ViewController.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 07/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit
import Verification

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
    
    private lazy var buttonToMethodMap: [UIButton: VerificationMethodType] = {
        return [smsButton: .sms, flashcallButton: .flashcall, calloutButton: .callout, seamlessButton: .seamless]
    }()
    
    private var selectedMethodButton: UIButton {
        return methodButtons.first { $0.isSelected }!
    }
    
    private weak var verificationDialogController: VerificationDialogController?
    private var verification: Verification?
    
    private lazy var globalConfig: SinchGlobalConfig = {
        return SinchGlobalConfig.Builder.instance()
            .authorizationMethod(AppKeyAuthorizationMethod(appKey: "9e556452-e462-4006-aab0-8165ca04de66")) //TODO handle appkeys differently
            .build()
    }()
    
    private var initData: VerificationInitData {
        let acceptedLanguages: [VerificationLanguage]
        do {
            acceptedLanguages = try acceptedLanguagesField.text?.nilIfEmpty()?.toLocaleList() ?? []
        } catch {
            acceptedLanguages = []
        }
        return VerificationInitData(
            usedMethod: buttonToMethodMap[selectedMethodButton] ?? .sms,
            number: phoneNumberTextField.text ?? "",
            custom: customField.text?.nilIfEmpty(),
            reference: referenceField.text?.nilIfEmpty(),
            honoursEarlyReject: honoursEarlyRejectField.isOn,
            acceptedLanguages: acceptedLanguages)
    }
    
    private var commonConfig: CommonVerificationInitializationParameters {
        return CommonVerificationInitializationParameters(
            globalConfig: self.globalConfig,
            verificationInitData: self.initData,
            initalizationListener: self,
            verificationListener: self
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
]
        [phoneNumberTextField, customField, referenceField, acceptedLanguagesField].forEach {
            $0?.delegate = self
        }
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
        return VerificationMethodsBuilder.createVerification(withParameters: self.commonConfig)
    }
    
}

extension VerificationController: VerificationListener {
    
    func onVerified() {
        print("OnVerified called")
        verificationDialogController?.showVerifiedMessage()
    }
    
    func onVerificationFailed(e: Error) {
        verificationDialogController?.showError(withMessage: e.localizedDescription)
    }
    
}

extension VerificationController: InitiationListener {
    
    func onInitiated(_ data: InitiationResponseData) {
        print("onInitiated called data is\n\(data)")
    }
    
    func onInitiationFailed(e: Error) {
        verificationDialogController?.showError(withMessage: e.localizedDescription)
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

extension VerificationController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
