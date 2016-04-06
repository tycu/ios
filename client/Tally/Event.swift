import Foundation

class Event {
    let iden: String, headline:String
    let summary: String?, imageUrl: String?, imageAttribution: String?
    let supportTweet: String?, opposeTweet: String?
    let created: NSDate, modified: NSDate
    let politician: Politician!
    var supportPacs = [Pac]()
    var opposePacs = [Pac]()
    let supportTotal: Int, opposeTotal: Int
    let barWeight: Double
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, headline = data["headline"] as? String, created = data["created"] as? Double, modified = data["modified"] as? Double, politician = data["politician"] as? [String : AnyObject], supportTotal = data["supportTotal"] as? Int, opposeTotal = data["opposeTotal"] as? Int {
            self.iden = iden
            self.headline = headline
            imageAttribution = data["imageAttribution"] as? String
            summary = data["summary"] as? String
            imageUrl = data["imageUrl"] as? String
            supportTweet = data["supportTweet"] as? String
            opposeTweet = data["opposeTweet"] as? String
            self.created = NSDate(timeIntervalSince1970: created)
            self.modified = NSDate(timeIntervalSince1970: modified)
            self.supportTotal = supportTotal
            self.opposeTotal = opposeTotal
            barWeight = data["barWeight"] as? Double ?? 0
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
            imageAttribution = nil
            imageUrl = nil
            supportTweet = nil
            opposeTweet = nil
            created = NSDate()
            modified = NSDate()
            politician = nil
            supportTotal = 0
            opposeTotal = 0
            barWeight = 0
            throw Error.QuietError("Invalid event data")
        }
    }
    
    func setThumbnail(imageView: UIImageView) {
        if politician.thumbnails.count == 0 {
            imageView.image = nil
        } else {
            let index = Int(created.timeIntervalSince1970) % politician.thumbnails.count
            politician.setThumbnail(imageView, thumbnailIndex: index)
        }
    }
}
