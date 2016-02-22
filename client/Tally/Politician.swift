class Politician {
    let iden: String, name: String
    let thumbnailUrl: String?
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, name = data["name"] as? String {
            self.iden = iden
            self.name = name
            self.thumbnailUrl = data["thumbnailUrl"] as? String
        } else {
            self.iden = ""
            self.name = ""
            self.thumbnailUrl = nil
            throw Error.QuietError("Invalid politician data")
        }
    }
}
