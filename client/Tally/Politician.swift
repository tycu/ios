import UIKit

class Politician {
    let iden: String, name: String
    let jobTitle: String?, thumbnailUrl: String?, twitterUsername: String?
    let supportTotal: Int, opposeTotal: Int
    let barWeight: Double
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, name = data["name"] as? String {
            self.iden = iden
            self.name = name
            jobTitle = data["jobTitle"] as? String
            thumbnailUrl = data["thumbnailUrl"] as? String
            twitterUsername = data["twitterUsername"] as? String
            supportTotal = data["supportTotal"] as? Int ?? 0
            opposeTotal = data["opposeTotal"] as? Int ?? 0
            barWeight = data["barWeight"] as? Double ?? 0
        } else {
            iden = ""
            name = ""
            jobTitle = nil
            thumbnailUrl = nil
            twitterUsername = nil
            supportTotal = 0
            opposeTotal = 0
            barWeight = 0
            throw Error.QuietError("Invalid politician data")
        }
    }
    
    func setThumbnail(imageView: UIImageView) {
        if thumbnailUrl != nil {
            let imgixConfig = "?dpr=\(UIScreen.mainScreen().scale)&h=100&w=100&fit=crop&crop=faces"
            imageView.layer.cornerRadius = imageView.frame.width / 2.0
            imageView.layer.masksToBounds = true
            imageView.sd_setImageWithURL(NSURL(string: thumbnailUrl! + imgixConfig))
        }
    }
}
