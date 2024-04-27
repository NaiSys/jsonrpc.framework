//
//  JSONRPCClient+Notifications.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 03/09/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <jsonrpc_framework/JSONRPCClient.h>

/**
 * Notificiation
 *
 * - Implements a way to use notifications in json rpc client. 
 *
 * Its important to understand that notifications does not  * allow using callbacks and therefor you 
 * need to make sure you call your server in the right way since there is no telling if * your notification was 
 * successfull or not.
 */
@interface JSONRPCClient (Notification)

/**
 * Sends a notification to json rpc server.
 *
 * @param method NSString Method to call
 */
- (void) notify:(NSString *)method;

/**
 * Sends a notification to json rpc server.
 *
 * @param method NSString Method to call
 * @param params id Either named or un-named parameter list (or nil)
 */
- (void) notify:(NSString *)method params:(id)params;

@end
