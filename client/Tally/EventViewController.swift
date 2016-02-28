import UIKit
import TTTAttributedLabel

class EventViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var headlineHolder: UIView!
    @IBOutlet weak var headline: MarkdownLabel!
    @IBOutlet weak var summary: MarkdownLabel!
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if event.created.isToday {
            title = "Today"
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            title = formatter.stringFromDate(event.created)
        }
        
        if event.imageUrl != nil && image.sd_imageURL() == nil {
            let imgixConfig = "?dpr=\(min(UIScreen.mainScreen().scale, 2))&h=\(Int(image.frame.height))&w=\(view.frame.width)&fit=crop&crop=entropy"
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
}
