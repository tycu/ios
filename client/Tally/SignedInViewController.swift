class SignedInViewController : UITableViewController {
    @IBOutlet weak var profileHolder: UIStackView!
    @IBOutlet weak var profilePictureHolder: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupationImage: UIImageView!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileHolder.hidden = true
        
        profilePictureHolder.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureHolder.layer.borderWidth = 2
        profilePictureHolder.layer.cornerRadius = profilePictureHolder.bounds.width / 2
        profilePictureHolder.layer.masksToBounds = true
        
        occupationImage.tintColor = UIColor.whiteColor()
        addressImage.tintColor = occupationImage.tintColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if profileHolder.hidden {
            Requests.post(Endpoints.getUserData, withBody: nil, completionHandler: { response, error in
                if response?.statusCode == 200 {
                    let user = User(data: response!.body!)
                    user.setThumbnail(self.profilePicture)
                    self.name.text = user.name
                    self.occupation.text = "Software Engineer @ Hipmunk"
                    self.address.text = "508 Octavia St #6\nSan Francisco, CA 94102"
                    
                    self.profileHolder.hidden = false
                    self.profileHolder.alpha = 0
                    UIView.animateWithDuration(0.3, animations: {
                        self.profileHolder.alpha = 1
                    })
                    
                    let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "edit")
                    editButton.tintColor = UIColor.whiteColor()
                    self.navigationController!.navigationBar.topItem!.rightBarButtonItem = editButton
                    self.navigationController!.navigationBar.barStyle = .Black
                }
            })
        }
    }
    
    func edit() {
        print("edit")
    }
}
