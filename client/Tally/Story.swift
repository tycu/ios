import Foundation

class Story {
    let iden: String, blurb: String, body: String
    let thumbnailUrl: String?
    let timestamp: NSTimeInterval
    
    init(data: [String : AnyObject]) {
        iden = data["iden"] as! String
        blurb = data["blurb"] as! String
        body = data["body"] as! String
        thumbnailUrl = data["thumbnailUrl"] as? String
        timestamp = data["timestamp"] as! NSTimeInterval
    }
}
