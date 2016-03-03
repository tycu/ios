class Profile {
    let iden: String, facebookId: String
    let name: String?, occupation: String?, employer: String?, streetAddress: String?, cityStateZip: String?
    
    init(data: [String : AnyObject]) {
        iden = data["iden"] as! String
        facebookId = data["facebookId"] as! String
        name = data["name"] as? String
        occupation = data["occupation"] as? String
        employer = data["employer"] as? String
        streetAddress = data["streetAddress"] as? String
        cityStateZip = data["cityStateZip"] as? String
    }
    
    func setThumbnail(imageView: UIImageView) {
        imageView.sd_setImageWithURL(NSURL(string: "https://graph.facebook.com/\(facebookId)/picture?type=large")!)
    }
}
