class Endpoints {
    private static let debug = "http://localhost:5000"
    private static let api = "https://tally-prototype.herokuapp.com"
    
    private static var host: String {
        #if DEBUG
            return debug
        #else
            return api
        #endif
    }
    
    static let stories = host + "/v1/stories"
}
