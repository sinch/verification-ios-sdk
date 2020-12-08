//
//  AutoVerificationConfig.swift
//  Verification
//
//  Created by Aleksander Wojcik on 08/12/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

/// Configuration used by [AutoVerificationMethod](x-source-tag://[AutoVerificationMethod]) to handle auto verification.
///
/// Use [AutoVerificationConfigBuilder](x-source-tag://[AutoVerificationConfigBuilder]) to create an instance of the configuration.
/// - TAG: AutoVerificationConfig
public class AutoVerificationConfig: VerificationMethodConfiguration {
    
    internal init(
        globalConfig: SinchGlobalConfig, number: String, custom: String? = nil,
        reference: String? = nil, honoursEarlyReject: Bool = true,
        acceptedLanguages: [VerificationLanguage] = []) {
        super.init(globalConfig: globalConfig, number: number, custom: custom,
                   reference: reference, honoursEarlyReject: honoursEarlyReject,
                   acceptedLanguages: acceptedLanguages)
    }
    
    /// Builder implementing fluent builder pattern to create [AutoVerificationConfig](x-source-tag://[AutoVerificationConfig]) objects.
    /// - TAG: AutoVerificationConfigBuilder
    public class Builder: BaseVerificationMethodConfigBuilder, AutoGlobalConfigSetter,
    AutoVerificationNumberSetter, AutoVerificationConfigCreator {
                
        private override init() {
            super.init()
        }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> AutoGlobalConfigSetter {
            return Builder()
        }
        
        /// Assigns globalConfig value to the builder.
        /// - Parameter sinchGlobalConfig: Global SDK configuration reference.
        /// - Returns: Instance of builder with assigned globalConfig field.
        public func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> AutoVerificationNumberSetter {
            return self.apply { $0.globalConfig = sinchGlobalConfig }
        }
        
        /// Assigns number value to the builder.
        /// - Parameter number: Phone number that needs be verified.
        /// - Returns: Instance of builder with assigned number field.
        public func number(_ number: String) -> AutoVerificationConfigCreator {
            return self.apply { $0.number = number }
        }
        
        /// Builds [AutoVerificationConfig](x-source-tag://[AutoVerificationConfig]) instance.
        /// - Returns: AutoVerificationConfig  instance with previously defined parameters.
        public func build() -> AutoVerificationConfig {
            return AutoVerificationConfig(
                globalConfig: self.globalConfig, number: self.number, custom: self.custom,
                reference: self.reference, honoursEarlyReject: self.honourEarlyReject, acceptedLanguages: self.acceptedLanguages
            )
        }
        
    }
}
