//
//  VerificationMethodsBuilder.swift
//  VerificationAll
//
//  Created by Aleksander Wojcik on 31/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore
import VerificationSms
import VerificationFlashcall

/// Helper  Helper object creating any type of verifications based on [CommonVerificationInitializationParameters](x-source-tag://[CommonVerificationInitializationParameters]).
public class VerificationMethodsBuilder {
    
    /// Creates a [Verification](x-source-tag://[Verification]) instance.
    /// - Parameter parameters: Properties of Verification that are used by each verification method builder.
    /// - Returns: Verification instance based on passed parameters.
    public static func createVerification(withParameters parameters: CommonVerificationInitializationParameters) -> Verification {
        switch parameters.verificationInitData.usedMethod {
        case .sms:
            return parameters.asSmsVerification
        case .flashcall:
            return parameters.asFlashcallVerification
        default:
            fatalError("Method \(parameters.verificationInitData.usedMethod) not yet supported")
        }
    }
    
}

extension CommonVerificationInitializationParameters {
    
    var asSmsVerification: Verification {
        return SmsVerificationMethod.Builder.instance().config(
            SmsVerificationConfig.Builder.instance()
                .globalConfig(self.globalConfig)
                .withVerificationProperties(self.verificationInitData)
                .build())
            .initiationListener(self.initiationListener)
            .verificationListener(self.verificationListener)
            .build()
    }
    
    var asFlashcallVerification: Verification {
        return FlashcallVerificationMethod.Builder.instance().config(
            FlashcallVerificationConfig.Builder.instance()
                .globalConfig(self.globalConfig)
                .withVerificationProperties(self.verificationInitData)
                .build())
            .initiationListener(self.initiationListener)
            .verificationListener(self.verificationListener)
            .build()
    }
    
}
