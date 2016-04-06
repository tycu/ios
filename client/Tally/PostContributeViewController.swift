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
        
        if let suggestedTweet = contributionNavigationController.inSupport == true ? contributionNavigationController.event.supportTweet : contributionNavigationController.event.opposeTweet, let twitterUsername = contributionNavigationController.event.politician.twitterUsername {
            let attributedString = NSMutableAttributedString(string: ".\(twitterUsername) \(suggestedTweet)")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Colors.twitter, range: NSMakeRange(1, twitterUsername.characters.count))
            
            let range = (attributedString.string as NSString).rangeOfString("@tallyus")
            attributedString.addAttribute(NSForegroundColorAttributeName, value: Colors.twitter, range: range)
            
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
        } else {
            showErrorDialogWithMessage("Twitter app not found.", inViewController: self)
        }
    }
    
    func shareOnFacebook() {
        let shareContent = FBSDKShareLinkContent()
        shareContent.contentTitle = contributionNavigationController.event.headline
        shareContent.contentURL = NSURL(string: "https://www.tally.us")
        
        if let imageUrl = contributionNavigationController.event.imageUrl {
            shareContent.imageURL = NSURL(string: imageUrl)
        }
        
        FBSDKShareDialog.showFromViewController(self, withContent: shareContent, delegate: nil)
    }
    
    func done() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
