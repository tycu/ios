import UIKit

class Politician {
    let iden: String, name: String
    let title: String?, thumbnailUrl: String?
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, name = data["name"] as? String {
            self.iden = iden
            self.name = name
            self.title = data["title"] as? String
            self.thumbnailUrl = data["thumbnailUrl"] as? String
        } else {
            iden = ""
            name = ""
            title = nil
            thumbnailUrl = nil
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
