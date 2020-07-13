//
//  SinchGlobalConfig.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

/**
 Global Sinch SDK configuration required by all verification methods.
 
 Use: [SinchGlobalConfig.Builder](x-source-tag://[SinchGlobalConfigBuilder]) to create an instance of configuration..
 */
class SinchGlobalConfig {
    
    let apiManager: ApiManager
    
    private init(apiManager: ApiManager){
        self.apiManager = apiManager
    }
    
    /**
     Builder implementing [fluent builder](https://dzone.com/articles/fluent-builder-pattern) pattern to create global config objects.
     - Tag: SinchGlobalConfigBuilder
     */
    class Builder: AuthorizationMethodSetter, GlobalConfigCreator {
        
        private init() {}
        
        /// Instance of builder that should be used to create global config object.
        /// - Returns: A builder instance.
        static func instance() -> AuthorizationMethodSetter {
            return SinchGlobalConfig.Builder()
        }
        
        private var authorizationMethod: AuthorizationMethod!
        
        /// Assigns authorization method to the builder.
        /// - Parameter authorizationMethod: [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) used for veryfing API requests.
        /// - Returns: Builder with assigned [AuthorizationMethod](x-source-tag://[AuthorizationMethod]).
        func authorizationMethod(_ authorizationMethod: AuthorizationMethod) -> GlobalConfigCreator {
            return apply { $0.authorizationMethod = authorizationMethod }
        }
        
        /// Builds global config instance.
        /// - Returns: Sinch global config instance with previously defined parameters.
        func build() -> SinchGlobalConfig {
            return SinchGlobalConfig(apiManager: ApiManager(authMethod: self.authorizationMethod))
        }
        
    }
}

extension SinchGlobalConfig.Builder: HasApply {}
