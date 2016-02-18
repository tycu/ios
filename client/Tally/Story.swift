import Foundation

class Story {
    let iden: String, shortDescription: String
    let thumbnailUrl: String?
    let timestamp: NSTimeInterval
    
    init(data: [String : AnyObject]) {
        iden = data["iden"] as! String
        shortDescription = data["shortDescription"] as! String
        thumbnailUrl = data["thumbnailUrl"] as? String
        timestamp = data["timestamp"] as! NSTimeInterval
    }
}
