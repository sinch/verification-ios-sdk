//
//  NetworkSocket.swift
//  Verification
//
//  Created by Aleksander Wojcik on 10/02/2022.
//  Copyright © 2022 Sinch. All rights reserved.
//

import Foundation
import Network

protocol SeamlessVerificationExecutorDelegate: AnyObject {
  
  func onResponseReceived(data: Data)
  
  func onError(error: Error)
  
}

internal class SeamlessVerificationExecutor {
  
  private let endpoint: URLComponents
  private let dispatchQueue = DispatchQueue.global(qos: .background)
  private let connection: NWConnection
  
  weak var delegate: SeamlessVerificationExecutorDelegate?
    
  init(endpoint: URLComponents) {
    self.endpoint = endpoint
    let tlsOptions = NWProtocolTLS.Options()
    let tcpOptions = NWProtocolTCP.Options()
    let port = endpoint.scheme == "http" ? NWEndpoint.Port.http : NWEndpoint.Port.https
    let params = NWParameters(tls: port == NWEndpoint.Port.https ? tlsOptions : nil, tcp: tcpOptions)
    params.requiredInterfaceType = .cellular
    let host = NWEndpoint.Host(endpoint.host!)
    
    self.connection =  NWConnection(host: host, port: port, using: params)
    self.connection.stateUpdateHandler = { [weak self] newState in
      print("TCP state change to: \(newState)")
      switch newState {
      case .ready:
        self?.executeGET()
        break
      case .waiting(let error), .failed(let error):
        self?.onDelegateThread {
          self?.delegate?.onError(error: error)
        }
        self?.disconnect(withErrorCause: error)
      default:
        break
      }
    }
    
  }
  
  func connect() throws {
    connection.start(queue: dispatchQueue)
  }
  
  func disconnect(withErrorCause error: Error?) {
    if connection.state != .cancelled {
      connection.cancel()
    }
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
      self.onDelegateThread {
        if let error = error {
          self.delegate?.onError(error: error)
        } else {
          self.delegate?.onResponseReceived(data: completeContent!)
        }
      }
    }
    
  }
  
  private func onDelegateThread(_ f: ()->Void) {
    DispatchQueue.main.sync {
      f()
    }
  }
  
  deinit {
    disconnect(withErrorCause: nil)
  }
  
}
