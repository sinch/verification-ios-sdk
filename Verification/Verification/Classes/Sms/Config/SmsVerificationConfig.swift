//
//  SmsVerificationConfiguration.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

/// Configuration used by [SmsVerificationMethod](x-source-tag://[SmsVerificationMethod]) to handle sms verification.
///
/// Use [SmsVerificationConfigBuilder](x-source-tag://[SmsVerificationConfigBuilder]) to create an instance of the configuration.
/// - TAG: SmsVerificationConfig
public class SmsVerificationConfig: VerificationMethodConfiguration {
    
    internal init(
        globalConfig: SinchGlobalConfig, number: String, custom: String? = nil,
        reference: String? = nil, honoursEarlyReject: Bool = true,
        acceptedLanguages: [VerificationLanguage] = []) {
        super.init(globalConfig: globalConfig, number: number, custom: custom,
                   reference: reference, honoursEarlyReject: honoursEarlyReject,
                   acceptedLanguages: acceptedLanguages)
    }
    
    /// Builder implementing fluent builder pattern to create [SmsVerificationConfig](x-source-tag://[SmsVerificationConfig]) objects.
    /// - TAG: SmsVerificationConfigBuilder
    public class Builder: BaseVerificationMethodConfigBuilder, SmsGlobalConfigSetter,
    SmsVerificationNumberSetter, SmsVerificationConfigCreator {
                
        private override init() {
            super.init()
        }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> SmsGlobalConfigSetter {
            return Builder()
        }
        
        /// Assigns globalConfig value to the builder.
        /// - Parameter sinchGlobalConfig: Global SDK configuration reference.
        /// - Returns: Instance of builder with assigned globalConfig field.
        public func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> SmsVerificationNumberSetter {
            return self.apply { $0.globalConfig = sinchGlobalConfig }
        }
        
        /// Assigns number value to the builder.
        /// - Parameter number: Phone number that needs be verified.
        /// - Returns: Instance of builder with assigned number field.
        public func number(_ number: String) -> SmsVerificationConfigCreator {
            return self.apply { $0.number = number }
        }
        
        /// Builds [SmsVerificationConfig](x-source-tag://[SmsVerificationConfig]) instance.
        /// - Returns: SmsVerificationConfig  instance with previously defined parameters.
        public func build() -> SmsVerificationConfig {
            return SmsVerificationConfig(
                globalConfig: self.globalConfig, number: self.number ?? "", custom: self.custom,
                reference: self.reference, honoursEarlyReject: self.honourEarlyReject, acceptedLanguages: self.acceptedLanguages
            )
        }
        
    }
}
