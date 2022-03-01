//
//  HttpRawResponseHandler.swift
//  Verification
//
//  Created by Aleksander Wojcik on 01/03/2022.
//  Copyright © 2022 Sinch. All rights reserved.
//

import Foundation

class HttpRawResponseHandler {
  
  private let httpStringResposne: String
  
  lazy var responseCode: Int? = extractResponseCode()
  
  init(_ httpStringResposne: String) {
    self.httpStringResposne = httpStringResposne
  }
  
  private func extractResponseCode() -> Int? {
    return httpStringResposne.split(separator: "\n").first.map { firstLine -> String? in
      guard let lastSpaceIndex = firstLine.lastIndex(of: " ") else { return nil }
      return firstLine[lastSpaceIndex...].trimmingCharacters(in: .whitespacesAndNewlines)
    }?.map { Int($0) } ?? nil
  }
  
}
