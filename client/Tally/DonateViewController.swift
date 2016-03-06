import ActionSheetPicker_3_0
import LocalAuthentication

class DonateViewController : UIViewController {
    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventHeadline: MarkdownLabel!
    @IBOutlet weak var eventGraph: SupportOpposeView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var pacName: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var donate: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var event: Event!
    var pac: Pac!
    var inSupport: Bool!
    private let amounts = [3, 10, 25, 50, 100]
    private var amountIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        event.politician.setThumbnail(eventThumbnail)
        
        eventHeadline.presentMarkdown(event.headline)
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: eventHeadline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        eventHeadline.attributedText = headlineAttributedString
        
        eventGraph.supportTotal = event.supportTotal
        eventGraph.opposeTotal = event.opposeTotal
        eventTime.text = event.created.humanReadableTimeSinceNow
        
        pacName.text = pac.name
        
        amount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "changeAmount:"))
        
        donate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "donate:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = inSupport == true ? "Support" : "Oppose"
        
        donate.setTitle(title, forState: .Normal)
    }
    
    func changeAmount(sender: UITapGestureRecognizer) {
        var amountStrings = [String]()
        for amount in amounts {
            amountStrings.append("$\(amount)")
        }
        
        ActionSheetStringPicker.showPickerWithTitle("Select Amount", rows: amountStrings, initialSelection: 0, doneBlock: { picker, index, value in
            self.amountIndex = index
        }, cancelBlock: nil, origin: sender.view)
    }
    
    func donate(sender: AnyObject) {
        let authContext = LAContext()
        var authError: NSError?
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Confirm contribution", reply: { success, error in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.makeDonation()
                    })
                } else {
                    if let error = error as? LAError {
                        if error == LAError.UserCancel || error == LAError.SystemCancel {
                            return
                        }
                    }
                    showErrorDialogWithMessage("Authentication failed, please try again.", inViewController: self)
                }
            })
        } else {
            makeDonation()
        }
    }
    
    private func makeDonation() {
        let amount = amounts[amountIndex]
        
        print("make donation \(amount)")
        
        lockUI()
        
//        var body = [String : AnyObject]()
//        body["eventIden"] = event.iden
//        body["pacIden"] = pac.iden
//        body["amount"] = amounts[amountIndex]
//        
//        Requests.post(Endpoints.createDonation, withBody: body, completionHandler: { response, error in
//            UserData.update({ succeeded in
//                self.indicator.hidden = true
//                
//                let donationNavigationController = self.parentViewController as! DonationNavigationController
//                donationNavigationController.amount = amount
//                donationNavigationController.next()
//            })
//        })
    }
    
    private func lockUI() {
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = false
        donate.hidden = true
        indicator.hidden = false
    }
    
    private func unlockUI() {
        navigationItem.leftBarButtonItem?.enabled = true
        navigationItem.rightBarButtonItem?.enabled = true
        donate.hidden = false
        indicator.hidden = true
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
