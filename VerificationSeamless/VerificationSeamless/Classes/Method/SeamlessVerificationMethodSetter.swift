//
//  SeamlessVerificationMethodSetter.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

public protocol SeamlessVerificationConfigSetter {
    func config(_ config: SeamlessVerificationConfig) -> VerificationMethodCreator
}
