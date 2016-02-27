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
        summary.presentMarkdown(event.summary)
    }
}
