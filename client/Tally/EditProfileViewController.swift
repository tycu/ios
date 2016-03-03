class EditProfileViewController : UIViewController {
    @IBOutlet var profileHolder: UIView!
    @IBOutlet var name: UITextField!
    @IBOutlet var occupation: UITextField!
    @IBOutlet var employer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "done")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancel")
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
