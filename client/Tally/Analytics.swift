import Mixpanel

class Analytics {
    
    static func track(event: String) {
        track(event, properties: [:])
    }
    
    static func track(event: String, properties: [String : AnyObject]) {
        var properties = properties
        
        if let userIden = UserData.instance?.profile.iden {
            properties["user_iden"] = userIden
        }
        
        Mixpanel.sharedInstance().track(event, properties: properties)
    }
}
