//
//  RPCRequest.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

public typealias RPCRequestCallback = (RPCResponse) -> Void

public class RPCRequest: NSObject {
    var version: String?
    var id: String?
    var method: String?
    var params: Any?
    var callback: RPCRequestCallback?
    
    public override init() {
        super.init()
        version = "2.0"
        id = "\(arc4random())"
        method = nil
        params = nil
        callback = nil
    }
    
    public class func requestWithMethod(method: String) -> RPCRequest {
        let request = RPCRequest()
        request.method = method
        return request
    }
    
    public class func requestWithMethod(method: String, params: Any) -> RPCRequest {
        let request = RPCRequest.requestWithMethod(method: method)
        request.params = params
        return request
    }
    
    public class func requestWithMethod(method: String, params: Any, callback: @escaping RPCRequestCallback) -> RPCRequest {
        let request = RPCRequest.requestWithMethod(method: method, params: params)
        request.callback = callback
        return request
    }
    
    func serialize() -> NSMutableDictionary {
        let payload: NSMutableDictionary = [:]
        if let version = self.version {
            payload["jsonrpc"] = version
        }
        if let method = self.method {
            payload["method"] = method
        }
        if let params = self.params {
            payload["params"] = params
        }
        if let id = self.id {
            payload["id"] = id
        }
        return payload
    }
    
    deinit {
        version = nil
        id = nil
        method = nil
        params = nil
        callback = nil
    }
}
