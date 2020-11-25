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
    
    @IBOutlet weak var phoneNumberTextField: PhoneNumberUITextField!
    @IBOutlet weak var envNameLabel: UILabel!
    
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
    private var selectedEnv: Environment = Environments[0] {
        didSet {
            envNameLabel.text = selectedEnv.name
            Constants.Api.userDefinedDomain = selectedEnv.domain
        }
    }
    
    private var globalConfig: SinchGlobalConfig {
        return SinchGlobalConfig.Builder.instance()
            .authorizationMethod(AppKeyAuthorizationMethod(appKey: selectedEnv.appKey))
            .build()
    }
    
    private var initData: VerificationInitData {
        return VerificationInitData(
            usedMethod: buttonToMethodMap[selectedMethodButton] ?? .sms,
            number: phoneNumberTextField.e164Number ?? "",
            custom: customField.text?.nilIfEmpty(),
            reference: referenceField.text?.nilIfEmpty(),
            honoursEarlyReject: honoursEarlyRejectField.isOn,
            acceptedLanguages: (try? acceptedLanguagesField.text?.nilIfEmpty()?.toLocaleList()) ?? [])
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
        [phoneNumberTextField, customField, referenceField, acceptedLanguagesField].forEach {
            $0?.delegate = self
        }
        envNameLabel.addInteraction(UIContextMenuInteraction(delegate: self))
    }
    
    @IBAction func didTapInitializeButton(_ sender: Any) {
        let verificationDialogController = VerificationDialogController.instantiate()
        verificationDialogController.delegate = self
        
        self.verificationDialogController = verificationDialogController
        self.verification = buildVerification()
        //If you use only single method of verification using specific builder might be more readable
        //self.verification = buildVerificationBuilderSpecific()
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
    
    private func buildVerificationBuilderSpecific() -> Verification {
        switch self.buttonToMethodMap[selectedMethodButton] {
        case .sms:
            return buildSmsVerification()
        case .callout:
            return buildCalloutVerification()
        case .flashcall:
            return buildFlashcallVerification()
        case .seamless:
            return buildSeamlessVerification()
        default:
            fatalError()
        }
    }
    
    private func buildSmsVerification() -> Verification {
        let smsConfiguration = SmsVerificationConfig.Builder.instance()
            .globalConfig(globalConfig)
            .number(self.phoneNumberTextField.e164Number ?? "")
            .acceptedLanguages((try? self.acceptedLanguagesField.text?.toLocaleList()) ?? [])
            .custom(self.customField.text)
            .honourEarlyReject(self.honoursEarlyRejectField.isSelected)
            .reference(self.referenceField.text)
            .build()
        
        let smsVerification = SmsVerificationMethod.Builder.instance()
            .config(smsConfiguration)
            .initiationListener(self)
            .verificationListener(self)
            .build()
        
        return smsVerification
    }
    
    private func buildFlashcallVerification() -> Verification {
        let flashcallConfiguration = FlashcallVerificationConfig.Builder.instance()
            .globalConfig(globalConfig)
            .number(self.phoneNumberTextField.e164Number ?? "")
            .acceptedLanguages((try? self.acceptedLanguagesField.text?.toLocaleList()) ?? [])
            .custom(self.customField.text)
            .honourEarlyReject(self.honoursEarlyRejectField.isSelected)
            .reference(self.referenceField.text)
            .build()
        
        let flashcallVerification = FlashcallVerificationMethod.Builder.instance()
            .config(flashcallConfiguration)
            .initiationListener(self)
            .verificationListener(self)
            .build()
        
        return flashcallVerification
    }
    
    private func buildCalloutVerification() -> Verification {
        let calloutConfiguration = CalloutVerificationConfig.Builder.instance()
            .globalConfig(globalConfig)
            .number(self.phoneNumberTextField.e164Number ?? "")
            .acceptedLanguages((try? self.acceptedLanguagesField.text?.toLocaleList()) ?? [])
            .custom(self.customField.text)
            .honourEarlyReject(self.honoursEarlyRejectField.isSelected)
            .reference(self.referenceField.text)
            .build()
        
        let calloutVerification = CalloutVerificationMethod.Builder.instance()
            .config(calloutConfiguration)
            .initiationListener(self)
            .verificationListener(self)
            .build()
        
        return calloutVerification
    }
    
    private func buildSeamlessVerification() -> Verification {
        let seamlessConfiguration = SeamlessVerificationConfig.Builder.instance()
            .globalConfig(globalConfig)
            .number(self.phoneNumberTextField.e164Number ?? "")
            .acceptedLanguages((try? self.acceptedLanguagesField.text?.toLocaleList()) ?? [])
            .custom(self.customField.text)
            .honourEarlyReject(self.honoursEarlyRejectField.isSelected)
            .reference(self.referenceField.text)
            .build()
        
        let seamlessVerification = SeamlessVerificationMethod.Builder.instance()
            .config(seamlessConfiguration)
            .initiationListener(self)
            .verificationListener(self)
            .build()
        
        return seamlessVerification
    }
}

extension VerificationController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { elem in
            let children = Environments.map { item in
                UIAction(title: item.name, state: (self.selectedEnv == item) ? .on : .off, handler: { _ in self.selectedEnv = item })
            }
            return UIMenu(title: "Envirnoments", options: .displayInline, children: children)
        })
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
