//
//  VerificationLanguage.swift
//  VerificationCore
//
//  Created by Aleksander Wojcik on 13/07/2020.
//  Copyright © 2020 Aleksander Wojcik. All rights reserved.
//

import Foundation

/// Language that can be used by the verification process. Instance of this classes can be used during the initialization of verification process.
class VerificationLanguage {
    
    /// Language tag (locale identifier). This consists of a 2-3 letter base language tag representing the language.
    let language: String
    
    /// Region for given language.
    let region: String?
    
    /// Weight factor (q-factor) used by http headers to describe the order of priority if more values are present. [More](https://developer.mozilla.org/en-US/docs/Glossary/Quality_values)
    let weight: Double?
    
    /// String representation of language weight.
    var weightString: String? {
        guard let weight = weight else { return nil }
        return VerificationLanguage.WeightFormatter.string(from: NSNumber(value: weight))
    }
    
    /// HTTP header representation of language.
    var httpHeader: String {
        let prefixedRegion = region?.prefixed(with: VerificationLanguage.RegionPrefix) ?? ""
        let prefixedWeight = weightString?.prefixed(with: VerificationLanguage.WeightPrefix) ?? ""
        return language + prefixedRegion + prefixedWeight
    }
    
    private static let RegionPrefix = "-", WeightPrefix = ";q="
    
    private static let WeightFormatter: NumberFormatter = {
        return NumberFormatter().apply {
            $0.numberStyle = .decimal
            $0.minimumFractionDigits = 0
            $0.maximumFractionDigits = 3
        }
    }()
    
    init(language: String, region: String? = nil, weight: Double? = nil) throws {
        if let weight = weight, (weight > 1 || weight < 0) {
            throw VerificationError.illegalArgument(message: "The weight value should be within range 0<=weight<=1")
        }
        self.language = language
        self.region = region
        self.weight = weight
    }
}

extension Array where Element == VerificationLanguage {
    
    var asLanguageString: String? {
        if isEmpty {
            return nil
        } else {
            return String(reduce("") { accumulator, language in
                accumulator + "," + language.httpHeader
            }.dropFirst())
        }
    }
    
}
