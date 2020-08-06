//
//  SeamlessVerificationConfig.swift
//  VerificationSeamless
//
//  Created by Aleksander Wojcik on 05/08/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import VerificationCore

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
        
        /// Assigns honourEarlyReject flag to the builder.
        /// - Parameter honourEarlyReject: Flag indicating if the verification process should honour early rejection rules.
        /// - Returns: Instance of builder with assigned honourEarlyReject flag.
        public func honourEarlyReject(_ honourEarlyReject: Bool) -> Self {
            return self.apply { $0.honourEarlyReject = honourEarlyReject }
        }
        
        /// Assigns custom string to the builder.
        /// - Parameter custom: Custom string that is passed with the initiation request.
        /// - Returns: Instance of builder with assigned custom field.
        public func custom(_ custom: String?) -> Self {
            return self.apply { $0.custom = custom }
        }
        
        /// Assigns reference string to the builder.
        /// - Parameter reference: Reference string that is passed with the initiation request for tracking purposes.
        /// - Returns: Instance of builder with assigned reference field.
        public func reference(_ reference: String?) -> Self {
            return self.apply { $0.reference = reference }
        }
        
        /// Assigns acceptedLanguages value to the builder.
        /// - Parameter acceptedLanguages: This verification method currently does not support accepted languages and this parameter is ignored.
        /// - Returns: Instance of builder with assigned acceptedLanguages field.
        public func acceptedLanguages(_ acceptedLanguages: [VerificationLanguage]) -> Self {
            return self.apply { $0.acceptedLanguages = acceptedLanguages }
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

extension SeamlessVerificationConfig.Builder: HasApply {}
