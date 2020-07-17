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

class ViewController: UIViewController {
    
    lazy var globalConfig: SinchGlobalConfig = {
        return SinchGlobalConfig.Builder.instance()
            .authorizationMethod(AppKeyAuthorizationMethod(appKey: "9e556452-e462-4006-aab0-8165ca04de66")) //TODO handle appkeys differently
            .build()
    }()
    
    lazy var smsConfiguarion: SmsVerificationConfig = {
        return SmsVerificationConfig.Builder.instance()
            .globalConfig(self.globalConfig)
            .number("+85269383732") //TODO change test number when sample app ready
            .build()
    }()
    
    lazy var verification: Verification = {
        return SmsVerificationMethod.Builder.instance()
            .config(self.smsConfiguarion)
            .initiationListener(self)
            .verificationListener(self)
            .build()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verification.initiate()
    }

}

extension ViewController: VerificationListener {}

extension ViewController: SmsInitiationListener {}
