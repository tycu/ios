class DonateViewController : UIViewController {
    @IBOutlet weak var eventThumbnail: UIImageView!
    @IBOutlet weak var eventHeadline: MarkdownLabel!
    @IBOutlet weak var eventGraph: SupportOpposeView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var donate: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var event: Event!
    var pac: Pac!
    var inSupport: Bool!
    
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
        
        donate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "donate:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = inSupport == true ? "Support" : "Oppose"
        
        donate.setTitle(title, forState: .Normal)
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
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
