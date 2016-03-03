import UIKit
import TTTAttributedLabel

class EventViewController: UIViewController {
    @IBOutlet weak var politicianHolder: UIView!
    @IBOutlet weak var politicianHolderHeight: NSLayoutConstraint!
    @IBOutlet weak var politicianThumbnail: UIImageView!
    @IBOutlet weak var politicianName: UILabel!
    @IBOutlet weak var politicianJobTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var headlineHolder: UIView!
    @IBOutlet weak var headline: MarkdownLabel!
    @IBOutlet weak var buttonsHolder: UIStackView!
    @IBOutlet weak var oppose: UIButton!
    @IBOutlet weak var support: UIButton!
    @IBOutlet weak var contribution: UILabel!
    @IBOutlet weak var summary: MarkdownLabel!
    var event: Event!
    var hidePolitician = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = simpleBackButton()
        
        if event.created.isToday {
            title = "Today"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            title = formatter.stringFromDate(event.created)
        }
        
        if event.politician != nil {
            politicianHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "goToPolitician:"))
            event.politician!.setThumbnail(politicianThumbnail)
            politicianName.text = event.politician!.name
            politicianJobTitle.text = event.politician!.jobTitle
        }
        
        if hidePolitician {
            politicianHolderHeight.constant = 0
        }
        
        if event.imageUrl != nil && image.sd_imageURL() == nil {
            let imgixConfig = "?dpr=\(min(UIScreen.mainScreen().scale, 2))&h=\(Int(image.frame.height))&w=\(view.frame.width)&fit=crop"
            let imageUrl = event.imageUrl! + imgixConfig
            if let parsedUrl = NSURL(string:imageUrl) {
                image.sd_setImageWithURL(parsedUrl)
            }
        }
        
        headlineHolder.layer.masksToBounds = false;
        headlineHolder.layer.shadowColor = UIColor.blackColor().CGColor
        headlineHolder.layer.shadowOffset = CGSizeMake(0, 1);
        headlineHolder.layer.shadowOpacity = 0.4;
        headlineHolder.layer.shadowRadius = 1.5;
        
        headline.presentMarkdown(event.headline)
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: headline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineParagraphStyle.lineHeightMultiple = 1.1
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        
        headline.attributedText = headlineAttributedString
        
        oppose.tintColor = Colors.support
        support.tintColor = Colors.support
        
        oppose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "oppose:"))
        support.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "support:"))
        
//        buttonsHolder.hidden = true
//        
//        contribution.text = "Supported ($5)"
        
        // Use serif font for the event summary
        let paragraphFont = UIFont(name: "Times New Roman", size: summary.font!.pointSize)!
        let strongFont = UIFont(name: "TimesNewRomanPS-BoldMT", size: summary.font!.pointSize)!
        let emphasisFont = UIFont(name: "TimesNewRomanPS-ItalicMT", size: summary.font!.pointSize)!
        summary.presentMarkdown(event.summary, paragraphFont: paragraphFont, strongFont: strongFont, emphasisFont: emphasisFont)
        
        // Increase the line height of each paragraph (this doensn't apply to the blank lines between paragraphs)
        let summaryAttributedString = NSMutableAttributedString(attributedString: summary.attributedText!)
        let nsString = summaryAttributedString.string as NSString
        let paragraphs = nsString.componentsSeparatedByString("\n")
        for paragraph in paragraphs {
            if !paragraph.isEmpty {
                let range = nsString.rangeOfString(paragraph)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 6
                summaryAttributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            }
        }
        summary.attributedText = summaryAttributedString
    }
    
    func goToPolitician(sender: AnyObject) {
        performSegueWithIdentifier("PoliticianSegue", sender: nil)
    }
    
    func oppose(sender: AnyObject) {
        performSegueWithIdentifier("DonationSegue", sender: sender)
    }
    
    func support(sender: AnyObject) {
        performSegueWithIdentifier("DonationSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PoliticianSegue" {
            let eventsViewController = segue.destinationViewController as! EventsViewController
            eventsViewController.politician = event.politician!
        } else if segue.identifier == "DonationSegue" {
            let donationNavigationController = segue.destinationViewController as! DonationNavigationController
            
            if Keychain.getAccessToken() == nil {
                let signInViewController = storyboard!.instantiateViewControllerWithIdentifier("SignInViewController")
                signInViewController.navigationItem.title = "Log In"
                signInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: signInViewController, action: "cancel")
                donationNavigationController.queue.append(signInViewController)
            }
            
//            let addCardViewController = storyboard!.instantiateViewControllerWithIdentifier("AddCardViewController")
//            addCardViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: addCardViewController, action: "cancel")
//            addCardViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: addCardViewController, action: "done")
//            addCardViewController.navigationItem.rightBarButtonItem!.enabled = false
//            donationNavigationController.queue.append(addCardViewController)
            
            let pacs = sender as? UIButton == support ? event.supportPacs : event.opposePacs
//            if pacs.count == 1 {
//                let donateViewController = storyboard!.instantiateViewControllerWithIdentifier("DonateViewController") as! DonateViewController
//                donateViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: donateViewController, action: "cancel")
//                donateViewController.event = event
//                donateViewController.pac = pacs[0]
//                donationNavigationController.queue.append(donateViewController)
//            } else {
                let pacsViewController = storyboard!.instantiateViewControllerWithIdentifier("PacsViewController") as! PacsViewController
                pacsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: pacsViewController, action: "cancel")
                pacsViewController.navigationItem.title = "Contribution Options"
                pacsViewController.event = event
                pacsViewController.options = pacs
                donationNavigationController.queue.append(pacsViewController)
//            }
        
            donationNavigationController.viewControllers.append(donationNavigationController.queue.removeFirst())
        }
    }
}
