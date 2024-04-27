//
//  RPCResponse.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

public class RPCResponse: NSObject {
    public var version: String?
    public var id: String?
    public var error: RPCError?
    public var result: Any?
    
    override init() {
        super.init()
        version = nil
        id = nil
        error = nil
        result = nil
    }
    
    convenience init(result: Any?, id: String?, version: String?) {
        self.init()
        self.version = version
        self.id = id
        self.result = result
    }
    
    class func responseWithError(error: RPCError) -> RPCResponse {
        let response = RPCResponse()
        response.error = error
        return response
    }
    
    deinit {
        version = nil
        error = nil
        result = nil
        id = nil
    }
}
