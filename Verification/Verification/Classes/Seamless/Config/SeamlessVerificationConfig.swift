//
//  SeamlessVerificationConfig.swift
//  Verification
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// Configuration used by [SeamlessVerificationMethod](x-source-tag://[SeamlessVerificationMethod]) to handle Seamless verification.
///
/// Use [SeamlessVerificationConfigBuilder](x-source-tag://[SeamlessVerificationConfigBuilder]) to create an instance of the configuration.
/// - TAG: SeamlessVerificationConfig
public class SeamlessVerificationConfig: VerificationMethodConfiguration {
    
    internal init(
        globalConfig: SinchGlobalConfig, number: String, custom: String? = nil,
        reference: String? = nil, honoursEarlyReject: Bool = true,
        acceptedLanguages: [VerificationLanguage] = []) {
        super.init(globalConfig: globalConfig, number: number, custom: custom,
                   reference: reference, honoursEarlyReject: honoursEarlyReject,
                   acceptedLanguages: acceptedLanguages)
    }
    
    /// Builder implementing fluent builder pattern to create [SeamlessVerificationConfig](x-source-tag://[SeamlessVerificationConfig]) objects.
    /// - TAG: SeamlessVerificationConfigBuilder
    public class Builder: BaseVerificationMethodConfigBuilder, SeamlessGlobalConfigSetter,
    SeamlessVerificationNumberSetter, SeamlessVerificationConfigCreator {
        
        private override init() {
            super.init()
        }
        
        /// Creates an instance of the builder.
        /// - Returns: Instance of the builder.
        public static func instance() -> SeamlessGlobalConfigSetter {
            return Builder()
        }
        
        /// Assigns globalConfig value to the builder.
        /// - Parameter sinchGlobalConfig: Global SDK configuration reference.
        /// - Returns: Instance of builder with assigned globalConfig field.
        public func globalConfig(_ sinchGlobalConfig: SinchGlobalConfig) -> SeamlessVerificationNumberSetter {
            return self.apply { $0.globalConfig = sinchGlobalConfig }
        }
        
        /// Assigns number value to the builder.
        /// - Parameter number: Phone number that needs be verified.
        /// - Returns: Instance of builder with assigned number field.
        public func number(_ number: String) -> SeamlessVerificationConfigCreator {
            return self.apply { $0.number = number }
        }
        
        /// Builds [SeamlessVerificationConfig](x-source-tag://[SeamlessVerificationConfig]) instance.
        /// - Returns: SeamlessVerificationConfig  instance with previously defined parameters.
        public func build() -> SeamlessVerificationConfig {
            return SeamlessVerificationConfig(
                globalConfig: self.globalConfig, number: self.number, custom: self.custom,
                reference: self.reference, honoursEarlyReject: self.honourEarlyReject, acceptedLanguages: self.acceptedLanguages
            )
        }
        
    }
    
}
