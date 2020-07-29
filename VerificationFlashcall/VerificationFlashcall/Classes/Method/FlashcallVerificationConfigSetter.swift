//
//  FlashcallVerificationConfigSetter.swift
//  VerificationFlashcall
//
//  Created by Aleksander Wojcik on 29/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

public protocol FlashcallVerificationConfigSetter {
    func config(_ config: FlashcallVerificationConfig) -> FlashcallVerificationMethodCreator
}
