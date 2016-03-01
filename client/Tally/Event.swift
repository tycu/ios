import Foundation

class Event {
    let iden: String, headline:String
    let summary: String?, imageUrl: String?
    let created: NSDate, modified: NSDate
    let politician: Politician?
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, headline = data["headline"] as? String, created = data["created"] as? Double, modified = data["modified"] as? Double, politician = data["politician"] as? [String : AnyObject] {
            self.iden = iden
            self.headline = headline
            self.summary = data["summary"] as? String
            self.imageUrl = data["imageUrl"] as? String
            self.created = NSDate(timeIntervalSince1970: created)
            self.modified = NSDate(timeIntervalSince1970: modified)
            do {
                self.politician = try Politician(data: politician)
            } catch let e {
                self.politician = nil
                throw e
            }
        } else {
            iden = ""
            headline = ""
            summary = ""
            imageUrl = nil
            created = NSDate()
            modified = NSDate()
            politician = nil
            throw Error.QuietError("Invalid event data")
        }
    }
}
