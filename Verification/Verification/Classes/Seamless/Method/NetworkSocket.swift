//
//  NetworkSocket.swift
//  Verification
//
//  Created by Aleksander Wojcik on 10/02/2022.
//  Copyright © 2022 Sinch. All rights reserved.
//

import Foundation
import Network

internal class NetworkSocket {
  
  let endpoint: URLComponents
  let dispatchQueue = DispatchQueue.global(qos: .background)
  
  var connection:NWConnection!
  var socket:NetworkSocket!

  init(endpoint: URLComponents) {
    self.endpoint = endpoint
  }
  
  func connect() throws {
    
    let tlsOptions = NWProtocolTLS.Options()
    let tcpOptions = NWProtocolTCP.Options()
    let port = endpoint.scheme == "http" ? NWEndpoint.Port.http : NWEndpoint.Port.https

    tcpOptions.noDelay = true
    tcpOptions.connectionTimeout = 1
    
    let params = NWParameters(tls: port == NWEndpoint.Port.https ? tlsOptions : nil, tcp: tcpOptions)
    params.requiredInterfaceType = .cellular
    let host = NWEndpoint.Host(endpoint.host!)
    
    self.connection =  NWConnection(host: host, port: port, using: params)
    connection.stateUpdateHandler = {(newState) in
      print("TCP state change to: \(newState)")
      switch newState {
      case .ready:
        self.executeGET()
        break
      default:
        break
    }
    }
    
    connection.start(queue: dispatchQueue)
    
  }
  
  func executeGET() {
    let requestStrFrmt =  "GET %@ HTTP/1.1\r\n%@Host: %@\r\n\r\n"
    let path = endpoint.path != "" ? endpoint.path : "/"
    let query = endpoint.query != nil ? "?" + endpoint.query! : ""
    let body =  String(format: requestStrFrmt, String(path + query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!.trimmingCharacters(in: .whitespacesAndNewlines) , "", endpoint.host!)

    print(body)
    let data = body.data(using: .utf8)
    connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed {
      error in
    }
    )
    
    
    self.connection.receive(minimumIncompleteLength: 1, maximumLength: 8192) {  completeContent, contentContext, isComplete, error in
      let stringResponse = String(decoding: completeContent!, as: UTF8.self)
      print("RESPONSE START \(contentContext) \(isComplete) \(error)")
      print("---------")
      print(stringResponse)
      let headers = stringResponse.components(separatedBy: "\n")
      let locationHeader = headers.first { item in
        item.starts(with: "Location:")
      }
      
      if let locationHeader = locationHeader {
        let range = locationHeader.range(of: "Location:")!
        let redirect = locationHeader[range.upperBound...].trimmingCharacters(in: .whitespacesAndNewlines)
        print("REDIRECT")
        print(redirect)
        print("REDIRECT DONE")

        let a = 0
        let c = a
        guard let urlComponents = URLComponents(string: redirect) else {
          return
        }
        self.socket = NetworkSocket(endpoint: urlComponents)
        do {
          try self.socket.connect()
        } catch {

        }
      }
      print("---------")
      print("RESPONSE END")
    }
    
    
      
  }
  
}
