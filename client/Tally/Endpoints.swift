class Endpoints {
    private static var api: String {
//        #if DEBUG
            return "http://localhost:5000"
//        #else
//            return "https://api.tally.us"
//        #endif
    }
    
    private static var generated: String {
//        #if DEBUG
            return "http://localhost:5001"
//        #else
//            return "https://generated.tally.us"
//        #endif
    }
    
    static let authenticate = api + "/v1/authenticate"
    static let getUserData = api + "/v1/get-user-data"
    static let updateProfile = api + "/v1/update-profile"
    static let setCard = api + "/v1/set-card"
    static let createContribution = api + "/v1/create-contribution"
    
    static let recentEvents = generated + "/v1/events/recent.json"
    static let topEvents = generated + "/v1/events/top.json"
    static let allTimeScoreboard = generated + "/v1/scoreboards/all-time.json"
}
