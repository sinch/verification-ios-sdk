//
//  SinchGlobalConfig.swift
//  Verification
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation
import Alamofire

/**
 Global Sinch SDK configuration required by all verification methods.
 
 Use: [SinchGlobalConfig.Builder](x-source-tag://[SinchGlobalConfigBuilder]) to create an instance of configuration..
 */
public class SinchGlobalConfig {
    
    let apiManager: ApiManager
    
    init(apiManager: ApiManager){
        self.apiManager = apiManager
    }
    
    /**
     Builder implementing [fluent builder](https://dzone.com/articles/fluent-builder-pattern) pattern to create global config objects.
     - Tag: SinchGlobalConfigBuilder
     */
    public class Builder: AuthorizationMethodSetter, GlobalConfigCreator {
        
        private init() {}
        
        /// Instance of builder that should be used to create global config object.
        /// - Returns: A builder instance.
        public static func instance() -> AuthorizationMethodSetter {
            return SinchGlobalConfig.Builder()
        }
        
        private var authorizationMethod: AuthorizationMethod!
        private var customInterceptors: [RequestInterceptor] = []
        
        /// Assigns authorization method to the builder.
        /// - Parameter authorizationMethod: [AuthorizationMethod](x-source-tag://[AuthorizationMethod]) used for veryfing API requests.
        /// - Returns: Builder with assigned [AuthorizationMethod](x-source-tag://[AuthorizationMethod]).
        public func authorizationMethod(_ authorizationMethod: AuthorizationMethod) -> GlobalConfigCreator {
            return apply { $0.authorizationMethod = authorizationMethod }
        }
        
        /// Assigns additional Alamofire Interceptors that will be fired whenever making http calls to Sinch REST API.
        /// - Parameter interceptors: Additional Alamofire Interceptors that will be fired whenever making http calls to Sinch REST API.
        /// - Returns: Builder with assigned interceptors.
        public func interceptors(_ interceptors: [RequestInterceptor]) -> GlobalConfigCreator {
            return apply { $0.customInterceptors = interceptors }
        }
        
        /// Builds global config instance.
        /// - Returns: Sinch global config instance with previously defined parameters.
        public func build() -> SinchGlobalConfig {
            return SinchGlobalConfig(apiManager: ApiManager(authMethod: self.authorizationMethod, customInterceptors: self.customInterceptors))
        }
        
    }
}

extension SinchGlobalConfig.Builder: HasApply {}
