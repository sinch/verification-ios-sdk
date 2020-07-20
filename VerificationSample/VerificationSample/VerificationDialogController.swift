//
//  VerificationDialogController.swift
//  VerificationSample
//
//  Created by Aleksander Wojcik on 20/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import UIKit
import VerificationCore

protocol VerificationDialogDelegate: class {
    func verificationDialog(_ verificationDialog: VerificationDialogController, didTypeVerificationCode verificationCode: String)
}

class VerificationDialogController: UIViewController {
    
    weak var delegate: VerificationDialogDelegate?
    
    static func instantiate() -> VerificationDialogController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "VerificationDialogController").apply {
                $0.modalPresentationStyle = .overCurrentContext
            } as! VerificationDialogController
    }
    
    @IBOutlet weak var verificationInProgressLabel: UILabel!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapVerifyButton(_ sender: Any) {
        delegate?.verificationDialog(self, didTypeVerificationCode: self.verificationCodeTextField.text ?? "")
    }
}
