class PostContributeViewController : UIViewController {
    @IBOutlet weak var tweetHolder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contributionNavigationController = parentViewController! as! ContributionNavigationController
        
        tweetHolder.layer.borderWidth = 1
        tweetHolder.layer.borderColor = UIColor(hex: "#DDDDDD").CGColor
        tweetHolder.layer.cornerRadius = 4
        tweetHolder.clipsToBounds = true
    }
    
    func done() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
