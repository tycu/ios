import Social

class PostContributeViewController : UIViewController {
    @IBOutlet weak var twitterHolder: UIView!
    @IBOutlet weak var tweetHolder: UIView!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var twitterImage: UIImageView!
    @IBOutlet weak var tweetButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contributionNavigationController = parentViewController! as! ContributionNavigationController
        
        tweetHolder.layer.borderWidth = 1
        tweetHolder.layer.borderColor = UIColor(hex: "#DDDDDD").CGColor
        tweetHolder.layer.cornerRadius = 4
        tweetHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(composeTweet)))
        
        let attributedString = NSMutableAttributedString(string: ".@donaldjtrump just contributed via @tallyus in support of your position on Saudi Arabia")
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Colors.twitter, range: NSMakeRange(1, 13))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: Colors.twitter, range: NSMakeRange(36, 8))
        
        tweet.attributedText = attributedString
        
        tweetButton.backgroundColor = Colors.twitter
        tweetButton.layer.cornerRadius = 6
        tweetButton.clipsToBounds = true
        
        twitterImage.tintColor = UIColor.whiteColor()
        
        tweetButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(composeTweet)))
    }
    
    func composeTweet() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText(tweet.attributedText!.string)
            
            presentViewController(tweetShare, animated: true, completion: nil)
        }
    }
    
    func done() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
