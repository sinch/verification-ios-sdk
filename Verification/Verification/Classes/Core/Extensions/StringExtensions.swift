//
//  StringExtensions.swift
//  Verification
//
//  Created by Aleksander Wojcik on 14/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

public extension String {
    
    func prefixed(with prefix: String) -> String {
        return prefix + self
    }
    
    func nilIfEmpty() -> String? {
        self.isEmpty ? nil : self
    }
}
