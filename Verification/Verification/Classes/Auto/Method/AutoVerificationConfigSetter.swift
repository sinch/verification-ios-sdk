//
//  AutoVerificationConfigSetter.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

public protocol AutoVerificationConfigSetter {
    func config(_ config: AutoVerificationConfig) -> VerificationMethodCreator
}
