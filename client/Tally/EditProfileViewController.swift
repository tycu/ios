class EditProfileViewController : UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileHolder: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var occupation: UITextField!
    @IBOutlet weak var employer: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var cityStateZip: UITextField!
    @IBOutlet weak var federalLaw: UIView!
    var required = false
    
    var inputIsValid: Bool {
        if required {
            if name.text == nil || name.text!.isEmpty || occupation.text == nil || occupation.text!.isEmpty || employer.text == nil || employer.text!.isEmpty || streetAddress.text == nil || streetAddress.text!.isEmpty || cityStateZip.text == nil || cityStateZip.text!.isEmpty {
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userData = UserData.instance {
            name.text = userData.profile.name
            occupation.text = userData.profile.occupation
            employer.text = userData.profile.employer
            streetAddress.text = userData.profile.streetAddress
            cityStateZip.text = userData.profile.cityStateZip
        } else {
            cancel()
        }
        
        name.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
        occupation.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
        employer.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
        streetAddress.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
        cityStateZip.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        textChanged()
        
        Analytics.track("enter_profile")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func textChanged() {
        navigationItem.rightBarButtonItem?.enabled = inputIsValid
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
        if !inputIsValid {
            return
        }
        
        lockUI()
        
        var body = [String : AnyObject]()
        body["name"] = name.text
        body["occupation"] = occupation.text
        body["employer"] = employer.text
        body["streetAddress"] = streetAddress.text
        body["cityStateZip"] = cityStateZip.text
        
        Requests.post(Endpoints.updateProfile, withBody: body, completionHandler: { response, error in
            if response?.statusCode == 200 {
                Analytics.track("updated_profile")
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
        if let parentViewController = parentViewController as? ContributionNavigationController {
            parentViewController.next()
        } else {
            dismiss()
        }
    }
    
    func cancel() {
        dismiss()
    }
    
    func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
}
