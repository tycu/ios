import ActionSheetPicker_3_0

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
    
    private var amounts = [3, 10, 25, 50, 100]
    
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
            
            print("\(self.amounts[index])")
            
        }, cancelBlock: nil, origin: sender.view)
    }
    
    func donate(sender: AnyObject) {
        lockUI()
        
        var body = [String : AnyObject]()
        body["eventIden"] = event.iden
        body["pacIden"] = pac.iden
        body["amount"] = 5
        
        Requests.post(Endpoints.createDonation, withBody: body, completionHandler: { response, error in
            UserData.update({ succeeded in
                self.indicator.hidden = true
                self.dismiss()
            })
        })
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
