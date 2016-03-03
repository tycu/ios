class Donation {
    let iden: String
    let event: Event!
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, event = data["event"] as? [String : AnyObject] {
            self.iden = iden
            do {
                self.event = try Event(data: event)
            } catch let e {
                self.event = nil
                throw e
            }
        } else {
            iden = ""
            event = nil
            throw Error.QuietError("Invalid donation data")
        }
    }
}