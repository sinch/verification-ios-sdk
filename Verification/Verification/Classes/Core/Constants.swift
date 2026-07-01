//
//  Constants.swift
//  Verification
//
//  Created by Aleksander Wojcik on 09/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

public enum Constants {
    
    public enum Api {
        
        public static var userDefinedDomain: String? = nil
        
        public static var userDefinedIndiaDomain: String? = nil

        static let version = "v1"
                
        static var domain: String {
            if let userDefinedDomain = userDefinedDomain { return userDefinedDomain }
            guard let urlPath = Bundle(for: ApiManager.self).infoDictionary!["API_URL"] as? String else {
                return "https://verification.api.sinch.com/"
            }
            return urlPath
        }
        
        /// India-specific API domain for seamless verification routing. The domain has to end with '/' sign.
        static var indiaDomain: String? {
            if let override = userDefinedIndiaDomain { return override }
            return nonEmptyPlistValue(forKey: "API_URL_IN")
        }
        
        public enum Seamless {
            
            public static var userDefinedDebugMsisdn: String? = nil
            
            public static var userDefinedDebugImsi: String? = nil
            
            static var debugMsisdn: String? {
                if let override = userDefinedDebugMsisdn { return override }
                return nonEmptyPlistValue(forKey: "DEBUG_MSISDN")
            }
            
            static var debugImsi: String? {
                if let override = userDefinedDebugImsi { return override }
                return nonEmptyPlistValue(forKey: "DEBUG_IMSI")
            }
        }
        
        private static func nonEmptyPlistValue(forKey key: String) -> String? {
            guard let value = Bundle(for: ApiManager.self).infoDictionary?[key] as? String,
                  !value.isEmpty else {
                return nil
            }
            return value
        }
        
    }
    
}
