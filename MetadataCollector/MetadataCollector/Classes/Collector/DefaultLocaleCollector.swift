//
//  DefaultLocaleCollector.swift
//  MetadataCollector
//
//  Created by Aleksander Wojcik on 22/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import UIKit

/// Metadata collector responsible for collecting device locale (string value).
class DefaultLocaleCollector: MetadataCollector {
    
    typealias CollectedType = String
    
    func collect() -> String {
        return Bundle.main.preferredLocalizations.first ?? ""
    }
    
}
