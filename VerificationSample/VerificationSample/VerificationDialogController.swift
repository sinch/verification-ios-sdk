//
//  VerificationDialogController.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit
import Verification
import SwiftEventBus
import CocoaLumberjack

protocol VerificationDialogDelegate: class {
    func verificationDialog(_ verificationDialog: VerificationDialogController, didTypeVerificationCode verificationCode: String, forMethod method: VerificationMethodType?)
    func verificationDialogCancelPressed(_ verificationDialog: VerificationDialogController)
}

class VerificationDialogController: UIViewController {
    
    weak var delegate: VerificationDialogDelegate?
    
    static let VerifiedMessage = "Successfully verified"
    
    static func instantiate() -> VerificationDialogController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VerificationDialogController").apply {
                $0.modalPresentationStyle = .overCurrentContext
            } as! VerificationDialogController
    }
    
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var verificationInProgressLabel: UILabel!
    @IBOutlet weak var smsCodeField: UITextField!
    @IBOutlet weak var flashcallCodeField: UITextField!
    @IBOutlet weak var calloutCodeField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var loggingLabel: UILabel!
    
    private lazy var inputToMethodMap = [
        smsCodeField: VerificationMethodType.sms,
        flashcallCodeField: VerificationMethodType.flashcall,
        calloutCodeField: VerificationMethodType.callout
    ]
    
    private var inputWithText: UITextField? {
        for inputView in inputToMethodMap.keys {
            if !(inputView?.text?.isEmpty ?? true) {
                return inputView
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardOnTouches()
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.gray.cgColor
        SwiftEventBus.onMainThread(self, name: SwiftEventBusLogger.DEBUG_EVENT_NAME) { [weak self] notification in
            guard let notification = notification?.object as? DDLogMessage else { return }
            let currentText = self?.loggingLabel.text ?? ""
            let modifiedText = currentText.isEmpty ? notification.message : "\(currentText)\n\(notification.message)"
            self?.loggingLabel.text = modifiedText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SwiftEventBus.unregister(self)
    }
    
    public func showVerifiedMessage() {
        messageLabel.textColor = .systemGreen
        messageLabel.text = VerificationDialogController.VerifiedMessage
        inputToMethodMap.forEach {
            $0.key?.isHidden = true
        }
        loaderContainer.isHidden = true
        verifyButton.isHidden = true
    }
    
    public func showError(withMessage message: String) {
        messageLabel.text = message
        messageLabel.textColor = .red
        loaderContainer.isHidden = true
    }
    
    public func adjustInitialInputsVisibility(forMethod method: VerificationMethodType) {
        if (method == VerificationMethodType.auto) {
            return //Every input visible initially
        }
        for inputView in inputToMethodMap.keys {
            inputView?.isHidden = method != inputToMethodMap[inputView]
        }
    }
    
    public func adjustInputsVisibility(usingInitiationResponseDetails initationResponseDetails: InitiationResponseData) {
        smsCodeField.isHidden = initationResponseDetails.smsDetails == nil
        flashcallCodeField.isHidden = initationResponseDetails.flashcallDetails == nil
        calloutCodeField.isHidden = initationResponseDetails.calloutDetails == nil
    }

    @IBAction func didTapVerifyButton(_ sender: Any) {
        guard let inputWithText = inputWithText else { return }
        delegate?.verificationDialog(self, didTypeVerificationCode: inputWithText.text ?? "", forMethod: inputToMethodMap[inputWithText])
    }
    
    @IBAction func inputCodeDidChange(_ sender: UITextField) {
        for inputView in inputToMethodMap.keys {
            if inputView != sender {
                inputView?.text = ""
            }
        }
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        delegate?.verificationDialogCancelPressed(self)
    }
    
    private func hideKeyboardOnTouches() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
