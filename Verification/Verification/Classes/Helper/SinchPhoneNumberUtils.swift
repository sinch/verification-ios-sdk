//
//  SinchPhoneNumberUtils.swift
//  Verification
//
//  Created by Aleksander Wojcik on 07/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import PhoneNumberKit

/// Helper object holding methods connected with phone number validation, formatting and processing.
public class SinchPhoneNumberUtils {
    
    /// Formats the specified phoneNumber tto the E164 representation.
    /// - Parameters:
    ///   - number: Phone number to format.
    ///   - countryIso: The ISO 3166-1 two letters country code.
    /// - Returns: The E164 representation, or null if the given phone number is not valid.
    public static func formatNumberToE164(_ number: String, forCountryIso countryIso: String = defaultCountryIso) -> String? {
        let numberKit = PhoneNumberKit()
        do {
            let phoneNumber = try numberKit.parse(number, withRegion: countryIso, ignoreType: false)
            return numberKit.format(phoneNumber, toType: .e164, withPrefix: true)
        } catch {
            return nil
        }
    }
    
    /// Checks if provided phone number is valid for given country code.
    /// - Parameters:
    ///   - number: Phone number to be checked.
    ///   - countryIso: The ISO 3166-1 two letters country code.
    /// - Returns: True if phone number is valid, false otherwise.
    public static func isPossiblePhoneNumber(_ number: String, forCountryIso countryIso: String = defaultCountryIso) -> Bool {
        return PhoneNumberKit().isValidPhoneNumber(number, withRegion: countryIso, ignoreType: false)
    }
    
    /// Country ISO 3166-1 code - based on the iPhone's carrier and if not available, the device region.
    public static var defaultCountryIso: String {
        return PhoneNumberKit.defaultRegionCode()
    }
}
