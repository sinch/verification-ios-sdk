//
//  ConfiguarionNameCollector.swift
//  Verification
//
//  Created by Aleksander Wojcik on 24/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

class ConfiguarionNameCollector: MetadataCollector {

typealias CollectedType = String
    
    func collect() -> String {
        return Bundle(for: ConfiguarionNameCollector.self).infoDictionary?["SchemeName"] as? String ?? ""
    }

}
