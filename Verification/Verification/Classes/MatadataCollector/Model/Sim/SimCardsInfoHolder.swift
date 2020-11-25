//
//  SimCardInfoHolder.swift
//  Verification
//
//  Created by Aleksander Wojcik on 23/07/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

/// This class is a wrapper for SimCardInfo objects array and it is used as a helper class to serialize those objects to JSON used by Sinch REST API.
struct SimCardsInfoHolder: Encodable {
    
    let info: [SimCardInfo]
    
    var simCardsCount: Int {
        return info.count
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SimCardsKey.self)
        try info.enumerated().forEach { index, simCardInfo in
            if let key = SimCardsKey(intValue: index + 1) {
                try container.encode(simCardInfo, forKey: key)
            }
        }
        try container.encode(simCardsCount, forKey: SimCardsKey.CountKey)
    }
    
    struct SimCardsKey: CodingKey {
        
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int? { return Int(stringValue) }
        
        init?(intValue: Int) { self.init(stringValue: String(intValue)) }
        
        static var CountKey: SimCardsKey {
            return SimCardsKey(stringValue: "count")! // It is safe to force unwrap this
        }
        
    }
}
