class EditProfileViewController : UIViewController {
    @IBOutlet var profileHolder: UIView!
    @IBOutlet var profilePictureHolder: UIView!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var name: UITextField!
    @IBOutlet var occupation: UITextField!
    @IBOutlet var employer: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.barStyle = .Black
        
        let doneButton = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
        doneButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = doneButton
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        cancelButton.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = cancelButton
        
        profilePictureHolder.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureHolder.layer.borderWidth = 2
        profilePictureHolder.layer.cornerRadius = profilePictureHolder.bounds.width / 2
        profilePictureHolder.layer.masksToBounds = true
        
        profilePicture.sd_setImageWithURL(NSURL(string: "https://graph.facebook.com/1682662308683021/picture?type=large")!)
    }
    
    private func lockUI() {
        navigationItem.leftBarButtonItem!.enabled = false
        navigationItem.rightBarButtonItem!.enabled = false
        profileHolder.hidden = true
    }
    
    private func unlockUI() {
        navigationItem.leftBarButtonItem!.enabled = true
        navigationItem.rightBarButtonItem!.enabled = true
        profileHolder.hidden = false
    }
    
    func done() {
        lockUI()
        
        var body = [String : AnyObject]()
        body["name"] = name.text
        body["occupation"] = occupation.text
        body["employer"] = employer.text
        
        Requests.post(Endpoints.updateProfile, withBody: body, completionHandler: { response, error in
            if response?.statusCode == 200 {
                self.next()
            } else {
                showErrorDialogWithMessage("Error updating profile, please try again.", inViewController: self)
                self.unlockUI()
            }
        })
    }
    
    func next() {
        dismiss()
    }
    
    func cancel() {
        dismiss()
    }
    
    func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
