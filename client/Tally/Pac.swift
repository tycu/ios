import UIKit

class Pac {
    let iden: String, name: String, summary: String?, color: String?
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, name = data["name"] as? String {
            self.iden = iden
            self.name = name
            summary = data["description"] as? String
            color = data["color"] as? String
        } else {
            iden = ""
            name = ""
            summary = ""
            color = ""
            throw Error.QuietError("Invalid pac data")
        }
    }
}
