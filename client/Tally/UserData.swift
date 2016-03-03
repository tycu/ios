class UserData {
    private(set) static var instance: UserData?
    
    let profile: Profile!
    let chargeable: Bool
    
    private init(data: [String : AnyObject]) throws {
        if let profile = data["profile"] as? [String : AnyObject] {
            self.profile = Profile(data: profile)
            chargeable = data["chargeable"] as? Bool ?? false
        } else {
            profile = nil
            chargeable = false
        }
    }
    
    class func update(completionHandler: ((Bool) -> Void)?) {
        assert(NSThread.currentThread().isMainThread)
        
        if Keychain.getAccessToken() == nil {
            completionHandler?(false)
            return
        }
        
        Requests.post(Endpoints.getUserData, withBody: nil, completionHandler: { response, error in
            if response?.statusCode == 200 {
                do {
                    UserData.instance = try UserData(data: response!.body!)
                    completionHandler?(true)
                } catch _ {
                    p("Ignoring invalid user data")
                }
            }
            
            completionHandler?(false)
        })
    }
}
