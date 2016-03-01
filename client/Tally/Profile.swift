class Profile {
    let iden: String, facebookId: String
    let name: String?, occupation: String?, employer: String?, address: String?
    
    init(data: [String : AnyObject]) {
        iden = data["iden"] as! String
        facebookId = data["facebookId"] as! String
        name = data["name"] as? String
        occupation = data["occupation"] as? String
        employer = data["employer"] as? String
        address = data["address"] as? String
    }
    
    func setThumbnail(imageView: UIImageView) {
        imageView.sd_setImageWithURL(NSURL(string: "https://graph.facebook.com/\(facebookId)/picture?type=large")!)
    }
}
