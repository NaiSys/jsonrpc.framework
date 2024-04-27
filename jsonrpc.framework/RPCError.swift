//
//  RPCError.swift
//  jsonrpc.framework
//
//  Created by Zadock Maloba on 27/04/2024.
//

import Foundation

public enum RPCErrorCode: Int {
    case parseError = -32700
    case invalidRequest = -32600
    case methodNotFound = -32601
    case invalidParams = -32602
    case internalError = -32603
    case serverError = 32000
    case networkError = 32001
}

public class RPCError: NSObject {
    let code: RPCErrorCode
    let message: String
    let data: Any?
    
    init(code: RPCErrorCode, message: String, data: Any? = nil) {
        self.code = code
        self.message = message
        self.data = data
    }
    
    convenience override init() {
        self.init(code: .serverError, message: "Server error")
    }
    
    convenience init(code: RPCErrorCode) {
        var message = ""
        switch code {
        case .parseError:
            message = "Parse error"
        case .internalError:
            message = "Internal error"
        case .invalidParams:
            message = "Invalid params"
        case .invalidRequest:
            message = "Invalid Request"
        case .methodNotFound:
            message = "Method not found"
        case .networkError:
            message = "Network error"
        default:
            message = "Server error"
        }
        self.init(code: code, message: message)
    }
    
    convenience init(dictionary errorDict: [String: Any]) {
        let errorCode = errorDict["code"] as? Int ?? RPCErrorCode.serverError.rawValue
        let errorMessage = errorDict["message"] as? String ?? "Unknown error"
        let errorData = errorDict["data"]
        self.init(code: RPCErrorCode(rawValue: errorCode) ?? .serverError, message: errorMessage, data: errorData)
    }
    
    public override var description: String {
        if let data = self.data {
            return "RPCError: \(self.message) (\(self.code)): \(data)."
        } else {
            return "RPCError: \(self.message) (\(self.code))."
        }
    }
    
    static func error(with code: RPCErrorCode) -> RPCError {
        return RPCError(code: code)
    }
    
    static func error(with dictionary: [String: Any]) -> RPCError? {
        guard let code = dictionary["code"] as? Int,
              let message = dictionary["message"] as? String else {
            return nil
        }
        
        let data = dictionary["data"]
        return RPCError(code: RPCErrorCode(rawValue: code) ?? .internalError, message: message, data: data)
    }
}
