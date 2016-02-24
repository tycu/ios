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
    
    static let events = host + "/v1/events"
}
