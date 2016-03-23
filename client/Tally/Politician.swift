import UIKit

class Politician {
    let iden: String, name: String
    let jobTitle: String?, twitterUsername: String?
    var thumbnails = [String]()
    let supportTotal: Int, opposeTotal: Int
    let barWeight: Double
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, name = data["name"] as? String {
            self.iden = iden
            self.name = name
            jobTitle = data["jobTitle"] as? String
            if let thumbnails = data["thumbnails"] as? [String] {
                self.thumbnails.appendContentsOf(thumbnails)
            }
            twitterUsername = data["twitterUsername"] as? String
            supportTotal = data["supportTotal"] as? Int ?? 0
            opposeTotal = data["opposeTotal"] as? Int ?? 0
            barWeight = data["barWeight"] as? Double ?? 0
        } else {
            iden = ""
            name = ""
            jobTitle = nil
            twitterUsername = nil
            supportTotal = 0
            opposeTotal = 0
            barWeight = 0
            throw Error.QuietError("Invalid politician data")
        }
    }
    
    func setThumbnail(imageView: UIImageView, thumbnailIndex: Int) {
        let imgixConfig = "?dpr=\(UIScreen.mainScreen().scale)&h=100&w=100&fit=crop&crop=faces"
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.sd_setImageWithURL(NSURL(string: thumbnails[thumbnailIndex] + imgixConfig))
    }
}
