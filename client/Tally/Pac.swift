import UIKit

class Pac {
    let iden: String, name: String
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, name = data["name"] as? String {
            self.iden = iden
            self.name = name
        } else {
            iden = ""
            name = ""
            throw Error.QuietError("Invalid pac data")
        }
    }
}
