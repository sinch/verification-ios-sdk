//
//  FlashcallVerificationConfig.swift
//  Verification
//
//  Created by Aleksander Wojcik on 28/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Configuration used by [FlashcallVerificationMethod](x-source-tag://[FlashcallVerificationMethod]) to handle flashcall verification.
///
/// Use [FlashcallVerificationConfigBuilder](x-source-tag://[FlashcallVerificationConfigBuilder]) to create an instance of the configuration.
/// - TAG: FlashcallVerificationConfig
public class FlashcallVerificationConfig: VerificationMethodConfiguration {
    
    internal init(
        globalConfig: SinchGlobalConfig, number: String, custom: String? = nil,
        reference: String? = nil, honoursEarlyReject: Bool = true,
        acceptedLanguages: [VerificationLanguage] = []) {
        super.init(globalConfig: globalConfig, number: number, custom: custom,
                   reference: reference, honoursEarlyReject: honoursEarlyReject,
                   acceptedLanguages: acceptedLanguages)
    }
    
    /// Builder implementing fluent builder pattern to create [FlashcallVerificationConfig](x-source-tag://[FlashcallVerificationConfig]) objects.
    /// - TAG: FlashcallVerificationConfigBuilder
    public class Builder: BaseVerificationMethodConfigBuilder, FlashcallGlobalConfigSetter,
    FlashcallVerificationNumberSetter, FlashcallVerificationConfigCreator {
        
        private override init() {
            super.init()
        }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> FlashcallGlobalConfigSetter {
            return Builder()
        }
        
        /// Assigns globalConfig value to the builder.
        /// - Parameter sinchGlobalConfig: Global SDK configuration reference.
        /// - Returns: Instance of builder with assigned globalConfig field.
        public func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> FlashcallVerificationNumberSetter {
            return self.apply { $0.globalConfig = sinchGlobalConfig }
        }
        
        /// Assigns number value to the builder.
        /// - Parameter number: Phone number that needs be verified.
        /// - Returns: Instance of builder with assigned number field.
        public func number(_ number: String) -> FlashcallVerificationConfigCreator {
            return self.apply { $0.number = number }
        }
        
        /// Builds [SmsVerificationConfig](x-source-tag://[SmsVerificationConfig]) instance.
        /// - Returns: SmsVerificationConfig  instance with previously defined parameters.
        public func build() -> FlashcallVerificationConfig {
            return FlashcallVerificationConfig(
                globalConfig: self.globalConfig, number: self.number, custom: self.custom,
                reference: self.reference, honoursEarlyReject: self.honourEarlyReject, acceptedLanguages: self.acceptedLanguages
            )
        }
        
    }
    
}
