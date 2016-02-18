class Endpoints {
    private static let debug = "https://tally-prototype.herokuapp.com"
    private static let api = "https://tally-prototype.herokuapp.com"
    
    private static var host: String {
        #if DEBUG
            return debug
        #else
            return api
        #endif
    }
    
    static let news = host + "/v1/news"
}
