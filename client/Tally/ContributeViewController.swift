import ActionSheetPicker_3_0
import LocalAuthentication

class ContributeViewController : UIViewController {
    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventHeadline: MarkdownLabel!
    @IBOutlet weak var eventGraph: SupportOpposeView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var pacName: UILabel!
    @IBOutlet weak var pacDescription: UILabel!
    @IBOutlet weak var amountBorder: UIView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var fee: UILabel!
    @IBOutlet weak var disclosure: UIButton!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var contribute: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var event: Event!
    var pac: Pac!
    var inSupport: Bool!
    private let amounts = [3, 10, 25, 100]
    private var amountIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        event.setThumbnail(eventThumbnail)
        
        eventHeadline.presentMarkdown(event.headline)
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: eventHeadline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        eventHeadline.attributedText = headlineAttributedString
        
        eventGraph.event = event
        
        eventTime.text = event.created.humanReadableTimeSinceNow
        
        pacName.text = pac.name
        pacDescription.text = pac.summary
        
        amountBorder.layer.borderWidth = 1
        amountBorder.layer.borderColor = UIColor(hex: "#DDDDDD").CGColor
        amountBorder.layer.cornerRadius = 2
        amountBorder.clipsToBounds = true
        amountBorder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeAmount(_:))))
        
        disclosure.addTarget(self, action: #selector(showFeeDisclosure), forControlEvents: .TouchUpInside)
        
        amount.text = "$\(amounts[amountIndex]).00"
        fee.text = "$0.99"
        total.text = "$\(Double(amounts[amountIndex]) + 0.99)"
        
        contribute.layer.borderColor = Colors.primary.CGColor
        contribute.layer.borderWidth = 1
        contribute.layer.cornerRadius = 6
        contribute.tintColor = Colors.primary
        contribute.addTarget(self, action: #selector(contributeTapped), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = inSupport == true ? "Support" : "Oppose"
    }
    
    func changeAmount(sender: UITapGestureRecognizer) {
        var amountStrings = [String]()
        for amount in amounts {
            amountStrings.append("$\(amount).00")
        }
        
        ActionSheetStringPicker.showPickerWithTitle("Select Amount", rows: amountStrings, initialSelection: amountIndex, doneBlock: { picker, index, value in
            self.amountIndex = index
            
            let amount = self.amounts[self.amountIndex]
            let fee = Double(amount) * 0.15
            
            self.amount.text = "$\(amount).00"
            
            if amount == 3 {
                self.fee.text = "$0.99"
                self.total.text = "$\(amount).99"
            } else {
                self.fee.text = "$\(String(format: "%.2f", fee))"
                self.total.text = "$\(String(format: "%.2f", Double(amount) + fee))"
            }
        }, cancelBlock: nil, origin: sender.view)
    }
    
    func showFeeDisclosure() {
        let alert = UIAlertController(title: "Fee Details", message: "Tally charges a fee to cover transaction and operating costs.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func contributeTapped() {
        let authContext = LAContext()
        var authError: NSError?
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Confirm contribution", reply: { success, error in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.makeContribution()
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
            let alert = UIAlertController(title: "Confirmation", message: "You will be charged " + total.text!, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.makeContribution()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    private func makeContribution() {
        let amount = amounts[amountIndex]
        
        print("make contribution \(amount)")
        
        lockUI()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.indicator.hidden = true
            
            let contributionNavigationController = self.parentViewController as! ContributionNavigationController
            contributionNavigationController.amount = amount
            contributionNavigationController.next()
        }
        
//        var body = [String : AnyObject]()
//        body["eventIden"] = event.iden
//        body["pacIden"] = pac.iden
//        body["amount"] = amounts[amountIndex]
//        
//        Requests.post(Endpoints.createContribution, withBody: body, completionHandler: { response, error in
//            UserData.update({ succeeded in
//                self.indicator.hidden = true
//
//                let contributionNavigationController = self.parentViewController as! ContributionNavigationController
//                contributionNavigationController.amount = amount
//                contributionNavigationController.next()
//            })
//        })
    }
    
    private func lockUI() {
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = false
        amountBorder.userInteractionEnabled = false
        contribute.hidden = true
        indicator.hidden = false
    }
    
    private func unlockUI() {
        navigationItem.leftBarButtonItem?.enabled = true
        navigationItem.rightBarButtonItem?.enabled = true
        amountBorder.userInteractionEnabled = true
        contribute.hidden = false
        indicator.hidden = true
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
