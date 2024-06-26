//
//  jsonrpc_frameworkTests.swift
//  jsonrpc.frameworkTests
//
//  Created by Zadock Maloba on 25/04/2024.
//

import XCTest
import Foundation

@testable import jsonrpc_framework

class jsonrpc_frameworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_version() throws {
        let tmp = RPCRequest()
        print("JSON-RPC Version: \(String(describing: tmp.version))")
        
        XCTAssert(tmp.version == "2.0")
    }
    
    func test_rpc() throws {
        print("Testing RPC request")
        let rpc = JSONRPCClient(serviceEndpoint: "https://api.example.com")
        
        rpc.invoke("getAppleProductIdentifiers", params: [], onCompleted: onResponse)
    }
    
    private func onResponse(response: RPCResponse?)->Void {
        print("getAppleProductIdentifiers");
        print("Respone: \(String(describing: response))");
        print("Error: \(String(describing: response?.error))");
        print("Result: \(String(describing: response?.result))");
        
        fflush(stdout)
    }

}
