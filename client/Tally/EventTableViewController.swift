import UIKit
import SDWebImage

class EventTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 338
        tableView.registerNib(UINib(nibName: "EventCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "EventCell")
    }
    
    func prepareCell(cell: EventCell, forEvent event: Event, showingPicture: Bool) {
        cell.headline.presentMarkdown(event.headline)
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: cell.headline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        cell.headline.attributedText = headlineAttributedString
        
        cell.time.text = event.created.humanReadableTimeSinceNow
        
        if event.imageUrl != nil && showingPicture {
            cell.picture.layer.cornerRadius = 6
            cell.picture.sd_setImageWithURL(NSURL(string: event.imageUrl! + "?w=512&fit=crop"))
        } else {
            cell.pictureHeight.constant = 0
            cell.pictureTopSpace.constant = 2
            cell.pictureBottomSpace.constant = 0
        }
    
        cell.graph.event = event
        
        if let contribution = UserData.instance?.eventIdenToContribution[event.iden] {
            contribution.setLabel(cell.contribution)
        } else {
            cell.contribution.text = nil
        }
    }
}
