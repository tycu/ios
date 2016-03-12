class UserData {
    static var instance: UserData?
    
    let profile: Profile!
    let chargeable: Bool
    var contributions = [Contribution]()
    var eventIdenToContribution = [String : Contribution]()
    
    private init(data: [String : AnyObject]) throws {
        if let profile = data["profile"] as? [String : AnyObject] {
            self.profile = Profile(data: profile)
            chargeable = data["chargeable"] as? Bool ?? false
            if let contributions = data["contribution"] as? [[String : AnyObject]] {
                for contribution in contributions {
                    do {
                        let contribution = try Contribution(data: contribution)
                        self.contributions.append(contribution)
                        self.eventIdenToContribution[contribution.event.iden] = contribution
                    } catch _ {
                        p("Skipping invalid donation")
                    }
                }
            }
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
                    EventBus.post("user_data_changed")
                    return
                } catch _ {
                    p("Ignoring invalid user data")
                }
            }
            
            completionHandler?(false)
        })
    }
}
