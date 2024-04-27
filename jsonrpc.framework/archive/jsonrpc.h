//
//  jsonrpc.h
//  jsonrpc
//
//  Created by Rasmus Styrk on 02/10/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//
//  Modified by Zadock Maloba 25/Apr/2024
//  Copyright (c) 2024 Zadock Maloba. All rights reserved.

#import <Foundation/Foundation.h>

#import <jsonrpc_framework/JSONKit.h>

#import <jsonrpc_framework/RPCError.h>
#import <jsonrpc_framework/RPCRequest.h>
#import <jsonrpc_framework/RPCResponse.h>

#import <jsonrpc_framework/JSONRPCClient+Invoke.h>
#import <jsonrpc_framework/JSONRPCClient+Notification.h>
#import <jsonrpc_framework/JSONRPCClient+Multicall.h>

#import <jsonrpc_framework/JSONRPCClient.h>

@interface jsonrpc : NSObject

@end
