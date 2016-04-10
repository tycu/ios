import Social
import FBSDKShareKit

class PostContributeViewController : UIViewController {
    @IBOutlet weak var twitterHolder: UIView!
    @IBOutlet weak var tweetHolder: UIView!
    @IBOutlet weak var tweet: UILabel!
    @IBOutlet weak var twitterImage: UIImageView!
    @IBOutlet weak var tweetButton: UIView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var facebookButton: UIView!
    
    private var contributionNavigationController: ContributionNavigationController {
        return parentViewController! as! ContributionNavigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let suggestedTweet = contributionNavigationController.event.tweets?[contributionNavigationController.selectedPac!.iden] {
            let attributedString = NSMutableAttributedString(string: suggestedTweet)
            
            let usernameRegex = try! NSRegularExpression(pattern: "@(\\w{1,15})\\b", options: [])
            
            var done = false
            var location = 0
            while !done {
                if let match = usernameRegex.firstMatchInString(attributedString.string, options: [.WithoutAnchoringBounds], range: NSRange(location: location, length: attributedString.length - location)) {
                    let oldLength = attributedString.length
                    print(match.range)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: Colors.twitter, range: match.range)
                    let newLength = attributedString.length
                    location = match.range.location + match.range.length + newLength - oldLength;
                } else {
                    done = true
                }
            }
            
            tweet.attributedText = attributedString
            
            tweetHolder.layer.borderWidth = 1
            tweetHolder.layer.borderColor = UIColor(hex: "#DDDDDD").CGColor
            tweetHolder.layer.cornerRadius = 4
            tweetHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(composeTweet)))
            
            tweetButton.backgroundColor = Colors.twitter
            tweetButton.layer.cornerRadius = 6
            tweetButton.clipsToBounds = true
            
            twitterImage.tintColor = UIColor.whiteColor()
            
            tweetButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(composeTweet)))
        } else {
            twitterHolder.hidden = true
        }
        
        facebookButton.layer.cornerRadius = 6
        facebookButton.clipsToBounds = true
        
        facebookImage.tintColor = UIColor.whiteColor()
        facebookImage.image = facebookImage.image!.imageWithRenderingMode(.AlwaysTemplate)
        
        facebookButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareOnFacebook)))
    }
    
    func composeTweet() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let tweetShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            tweetShare.setInitialText(tweet.attributedText!.string)
            
            presentViewController(tweetShare, animated: true, completion: nil)
            
            Analytics.track("compose_tweet")
        } else {
            showErrorDialogWithMessage("Twitter app not found.", inViewController: self)
        }
    }
    
    func shareOnFacebook() {
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentTitle = contributionNavigationController.event.headline
        shareContent.contentURL = NSURL(string: "https://itunes.apple.com/us/app/tally-politics-in-your-pocket/id1100538994?ls=1&mt=8")
        
        if let imageUrl = contributionNavigationController.event.imageUrl {
            shareContent.imageURL = NSURL(string: imageUrl)
        }
        
        FBSDKShareDialog.showFromViewController(self, withContent: shareContent, delegate: nil)
        
        Analytics.track("share_on_facebook")
    }
    
    func done() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
