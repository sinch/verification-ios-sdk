//
//  VerificationDialogController.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit
import Verification

protocol VerificationDialogDelegate: class {
    func verificationDialog(_ verificationDialog: VerificationDialogController, didTypeVerificationCode verificationCode: String)
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
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    public func showVerifiedMessage() {
        messageLabel.textColor = .systemGreen
        messageLabel.text = VerificationDialogController.VerifiedMessage
        verificationCodeTextField.isHidden = true
        loaderContainer.isHidden = true
        verifyButton.isHidden = true
    }
    
    public func showError(withMessage message: String) {
        messageLabel.text = message
        messageLabel.textColor = .red
        loaderContainer.isHidden = true
    }

    @IBAction func didTapVerifyButton(_ sender: Any) {
        delegate?.verificationDialog(self, didTypeVerificationCode: self.verificationCodeTextField.text ?? "")
    }
    
    @IBAction func didTapCancelButton(_ sender: Any) {
        delegate?.verificationDialogCancelPressed(self)
    }
}
