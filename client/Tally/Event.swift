import Foundation

class Event {
    let iden: String, summary: String
    let created: NSDate, modified: NSDate
    let politician: Politician?
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, summary = data["summary"] as? String, created = data["created"] as? Double, modified = data["modified"] as? Double, politician = data["politician"] as? [String : AnyObject] {
            self.iden = iden
            self.summary = summary
            self.created = NSDate(timeIntervalSince1970: created)
            self.modified = NSDate(timeIntervalSince1970: modified)
            do {
                self.politician = try Politician(data: politician)
            } catch let e {
                self.politician = nil
                throw e
            }
        } else {
            self.iden = ""
            self.summary = ""
            self.created = NSDate()
            self.modified = NSDate()
            self.politician = nil
            throw Error.QuietError("Invalid event data")
        }
    }
}
