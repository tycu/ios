import UIKit
import TTTAttributedLabel
import JTSImageViewController

class EventViewController: UIViewController {
    @IBOutlet weak var politicianHolder: UIView!
    @IBOutlet weak var politicianHolderHeight: NSLayoutConstraint!
    @IBOutlet weak var politicianThumbnail: UIImageView!
    @IBOutlet weak var politicianName: UILabel!
    @IBOutlet weak var politicianJobTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var attribution: MarkdownLabel!
    @IBOutlet weak var headlineHolder: UIView!
    @IBOutlet weak var headline: MarkdownLabel!
    @IBOutlet weak var graph: SupportOpposeView!
    @IBOutlet weak var oppose: UIButton!
    @IBOutlet weak var support: UIButton!
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
        
        politicianHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToPolitician)))
        event.setThumbnail(politicianThumbnail)
        politicianName.text = event.politician!.name
        politicianJobTitle.text = event.politician!.jobTitle
        
        if hidePolitician {
            politicianHolderHeight.constant = 0
        }
        
        if event.imageUrl != nil && image.sd_imageURL() == nil {
            let imgixConfig = "?w=512&fit=crop"
            let imageUrl = event.imageUrl! + imgixConfig
            if let parsedUrl = NSURL(string:imageUrl) {
                image.sd_setImageWithURL(parsedUrl)
                image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
            }
        }
        
        attribution.presentMarkdown(event.imageAttribution)
        
        headline.presentMarkdown(event.headline)
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: headline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineParagraphStyle.lineHeightMultiple = 1.1
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        headline.attributedText = headlineAttributedString
        
        graph.event = event
        
        oppose.layer.borderColor = Colors.secondary.CGColor
        oppose.layer.borderWidth = 1
        oppose.layer.cornerRadius = 6
        oppose.tintColor = Colors.secondary
        oppose.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(oppose(_:))))
        
        support.layer.borderColor = Colors.secondary.CGColor
        support.layer.borderWidth = 1
        support.layer.cornerRadius = 6
        support.tintColor = Colors.secondary
        support.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(support(_:))))
        
        summary.presentMarkdown(event.summary)
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if event.supportPacs.count == 0 && event.opposePacs.count == 0 {
        }
        
        if let contribution = UserData.instance?.eventIdenToContribution[event.iden] {
        }
    }
    
    func goToPolitician() {
        performSegueWithIdentifier("PoliticianSegue", sender: nil)
    }
    
    func imageTapped() {
        let imgixConfig = "?w=1024&fit=crop"
        let imageUrl = event.imageUrl! + imgixConfig
        if let parsedUrl = NSURL(string:imageUrl) {
            let info = JTSImageInfo()
            info.imageURL = parsedUrl
            
            let viewer = JTSImageViewController(imageInfo: info, mode: .Image, backgroundStyle: .None)
            viewer.modalPresentationStyle = .OverFullScreen
            viewer.showFromViewController(self, transition: .FromOffscreen)
        }
    }
    
    func oppose(sender: AnyObject) {
        performSegueWithIdentifier("ContributionSegue", sender: sender)
    }
    
    func support(sender: AnyObject) {
        performSegueWithIdentifier("ContributionSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PoliticianSegue" {
            let eventsViewController = segue.destinationViewController as! EventsViewController
            eventsViewController.politician = event.politician!
        } else if segue.identifier == "ContributionSegue" {
            let contributionNavigationController = segue.destinationViewController as! ContributionNavigationController
            contributionNavigationController.prepareForEvent(event, inSupport: (sender as! UITapGestureRecognizer).view == support)
        }
    }
}
