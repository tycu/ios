import Foundation

class Requests {
    private static let session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    
    private static func buildRequestTo(url: String) -> NSMutableURLRequest {
        let wrapped: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        wrapped.addValue("Tally iOS \(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String) (gzip)", forHTTPHeaderField: "User-Agent")
        wrapped.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        wrapped.addValue("application/json", forHTTPHeaderField: "Accept")
        if let token = Keychain.getPassword() {
            wrapped.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        wrapped.timeoutInterval = 10
        return wrapped
    }
    
    static func get(url: String, completionHandler: (Response?, NSError?) -> Void) {
        let wrapped = buildRequestTo(url)
        wrapped.HTTPMethod = "GET"
        makeRequest(wrapped, completionHandler: completionHandler)
    }

    static func post(url: String, withBody body: [String : AnyObject], completionHandler: (Response?, NSError?) -> Void) {
        let wrapped = buildRequestTo(url)
        wrapped.HTTPMethod = "POST"
        wrapped.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body, options: [])
        makeRequest(wrapped, completionHandler: completionHandler)
    }
    
    private static func makeRequest(wrapped: NSMutableURLRequest, completionHandler: (Response?, NSError?) -> Void) {
        p("\(wrapped.HTTPMethod) \(wrapped.URL!)")
        
        session.dataTaskWithRequest(wrapped, completionHandler: { data, response, error -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(nil, error)
                })
                return
            }
            
            let httpResponse = response as! NSHTTPURLResponse
            var body: [String: AnyObject]?
            
            if httpResponse.statusCode == 200 {
                do {
                    body = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject]
                } catch let e {
                    p(e)
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(nil, NSError(domain:NSBundle.mainBundle().bundleIdentifier!, code:0, userInfo:[NSLocalizedDescriptionKey: "Error processing network response"]))
                    })
                    return
                }
            } else if httpResponse.statusCode == 401 {
                Keychain.clear()
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completionHandler(Response(statusCode: httpResponse.statusCode, body: body), nil)
            })
        }).resume()
    }
    
    class Response {
        let statusCode: Int
        let body: [String : AnyObject]?
        
        init(statusCode: Int, body: [String : AnyObject]?) {
            self.statusCode = statusCode
            self.body = body
        }
    }
}
