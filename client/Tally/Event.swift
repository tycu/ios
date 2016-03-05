import Foundation

class Event {
    let iden: String, headline:String
    let summary: String?, imageUrl: String?
    let created: NSDate, modified: NSDate
    let politician: Politician!
    var supportPacs = [Pac]()
    var opposePacs = [Pac]()
    let supportTotal: Int, opposeTotal: Int
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, headline = data["headline"] as? String, created = data["created"] as? Double, modified = data["modified"] as? Double, politician = data["politician"] as? [String : AnyObject], supportTotal = data["supportTotal"] as? Int, opposeTotal = data["opposeTotal"] as? Int {
            self.iden = iden
            self.headline = headline
            summary = data["summary"] as? String
            imageUrl = data["imageUrl"] as? String
            self.created = NSDate(timeIntervalSince1970: created)
            self.modified = NSDate(timeIntervalSince1970: modified)
            self.supportTotal = supportTotal
            self.opposeTotal = opposeTotal
            do {
                self.politician = try Politician(data: politician)
            } catch let e {
                self.politician = nil
                throw e
            }
            if let supportPacs = data["supportPacs"] as? [[String : AnyObject]] {
                for pac in supportPacs {
                    self.supportPacs.append(try Pac(data: pac))
                }
            }
            if let opposePacs = data["opposePacs"] as? [[String : AnyObject]] {
                for pac in opposePacs {
                    self.opposePacs.append(try Pac(data: pac))
                }
            }
        } else {
            iden = ""
            headline = ""
            summary = ""
            imageUrl = nil
            created = NSDate()
            modified = NSDate()
            politician = nil
            supportTotal = 0
            opposeTotal = 0
            throw Error.QuietError("Invalid event data")
        }
    }
}
