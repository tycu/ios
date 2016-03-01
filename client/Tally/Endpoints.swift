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
    static let getProfie = host + "/v1/get-profile"
    
    static let recentEvents = "https://generated.tally.us/v1/events/recent.json"
    static let topEvents = "https://generated.tally.us/v1/events/top.json"
}
