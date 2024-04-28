# jsonrpc.framework

A Swift framework for handling JSON-RPC requests and responses.

## Example

* Initialize a JSONRPCClient
```
struct LoginField: View {
    @State private var uName: String = ""
    @State private var pWord: String = ""
    @State private var alertShowing: Bool = false
    @State private var alertMessage: String = ""
    
    private var rpc = JSONRPCClient(serviceEndpoint: "http://192.168.1.66:8069/jsonrpc")
    
    var body: some View {
```
* Send requests and add callbacks for successful and unsuccessful requests

```
func fetchData() {
        rpc.invoke("call", params: [
            "service": "common",
            "method": "login",
            "args": [ "bitnami", uName, pWord ]
        ], onCompleted: onResponse)
        
    }
    
    private func onResponse(response: RPCResponse?) {
        NSLog("Respone: \(String(describing: response))");
        NSLog("Error: \(String(describing: response?.error))");
        NSLog("Result: \(String(describing: response?.result))");
        
        guard response?.error == nil else {
            alertShowing = true
            alertMessage = String(describing: response?.error)
            return
        }
        
        guard response?.result != nil, let resp = response?.result!, (resp as! Int) != 0 else {
            // Handle the case where the service endpoint URL is invalid
            NSLog("Warning: Invalid Username/Password")
            alertShowing = true
            alertMessage = String("Warning: Invalid Username/Password")
            return
        }
    }
```
