//
//  ApiResponseExtensions.swift
//  Verification
//
//  Created by Aleksander Wojcik on 15/09/2020.
//  Copyright © 2020 Sinch. All rights reserved.
//

import Foundation

fileprivate let GenerationDateFormat = "E, dd MMM y HH:mm:ss zzz"

extension ResponseHeaders {

    var contentLanguage: VerificationLanguage? {
        let contentLanguageHeader = self["Content-Language"]
        guard let contentLanguageHeaderUnwrapped = contentLanguageHeader else { return nil }
        return VerificationLanguage(contentLanguageHeader: contentLanguageHeaderUnwrapped)
    }
    
    var generationDate: Date? {
        let dateHeader = self["Date"]
        guard let dateHeaderUnwrapped = dateHeader else { return nil }
        let formatter = DateFormatter().apply {
            $0.dateFormat = GenerationDateFormat
        }
        return formatter.date(from: dateHeaderUnwrapped)
    }
    
}
