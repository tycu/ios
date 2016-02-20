import Foundation

class Event {
    let iden: String, summary: String
    let thumbnailUrl: String?
    let created: NSTimeInterval, modified: NSTimeInterval
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, summary = data["summary"] as? String, created = data["created"] as? NSTimeInterval, modified = data["modified"] as? NSTimeInterval {
            self.iden = iden
            self.summary = summary
            self.created = created
            self.modified = modified
            thumbnailUrl = data["thumbnailUrl"] as? String
        } else { // This is stupid but required right now
            self.iden = ""
            self.summary = ""
            self.thumbnailUrl = nil
            self.created = 0
            self.modified = 0
            throw Error.QuietError("Invalid event data")
        }
    }
}
