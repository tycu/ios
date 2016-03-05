class Endpoints {
    private static let debug = "http://localhost:5000"
    private static let api = "https://api.tally.us"
    
    private static var host: String {
        #if DEBUG
            return debug
        #else
            return api
        #endif
    }
    
    static let authenticate = host + "/v1/authenticate"
    static let getUserData = host + "/v1/get-user-data"
    static let updateProfile = host + "/v1/update-profile"
    static let setCard = host + "/v1/set-card"
    static let createDonation = host + "/v1/create-donation"
    
    static let recentEvents = "https://generated.tally.us/v1/events/recent.json"
    static let topEvents = "https://generated.tally.us/v1/events/top.json"
    static let allTimeScoreboard = "https://generated.tally.us/v1/scoreboards/all-time.json"
}
