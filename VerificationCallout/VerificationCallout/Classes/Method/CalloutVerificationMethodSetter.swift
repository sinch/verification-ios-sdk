//
//  CalloutVerificationMethodSetter.swift
//  VerificationCallout
//
//  Created by Aleksander Wojcik on 03/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

public protocol CalloutVerificationConfigSetter {
    func config(_ config: CalloutVerificationConfig) -> CalloutVerificationMethodCreator
}
