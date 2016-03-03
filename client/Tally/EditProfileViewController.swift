class EditProfileViewController : UIViewController {
    @IBOutlet weak var profileHolder: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var employer: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var cityStateZip: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
        
        if let userData = UserData.instance {
            name.text = userData.profile.name
            occupation.text = userData.profile.occupation
            employer.text = userData.profile.employer
            streetAddress.text = userData.profile.streetAddress
            cityStateZip.text = userData.profile.cityStateZip
        } else {
            dismiss()
        }
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
        body["streetAddress"] = streetAddress.text
        body["cityStateZip"] = cityStateZip.text
        
        Requests.post(Endpoints.updateProfile, withBody: body, completionHandler: { response, error in
            if response?.statusCode == 200 {
                UserData.update({ succeeded in
                    self.next()
                })
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
