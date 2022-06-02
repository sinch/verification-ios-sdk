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
  
  lazy var locationHeader: String? = extractHeader(withName: "Location:")
  
  init(_ httpStringResposne: String) {
    self.httpStringResposne = httpStringResposne
  }
  
  private func extractResponseCode() -> Int? {
    return httpStringResposne.split(separator: " ").first { item in
      Int(item) != nil
    }.map { Int($0) } ?? nil
  }
  
  private func extractHeader(withName name: String) -> String? {
    guard let range = httpStringResposne.range(of: name) else {
      return nil
    }
    let subString = httpStringResposne[range.upperBound..<httpStringResposne.endIndex].trimmingCharacters(in: .whitespacesAndNewlines)
    let components = subString.components(separatedBy: .newlines)
    return components[0].trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
}
