import UIKit
import SDWebImage

class EventTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        tableView.registerNib(UINib(nibName: "EventCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "EventCell")
    }
    
    func prepareCell(cell: EventCell, withEvent event: Event) {
        event.setThumbnail(cell.thumbnail)
        cell.headline.presentMarkdown(event.headline)
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: cell.headline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        cell.headline.attributedText = headlineAttributedString
        
        cell.time.text = event.created.humanReadableTimeSinceNow
        
        cell.graph.event = event
        
        if let contribution = UserData.instance?.eventIdenToContribution[event.iden] {
            contribution.setLabel(cell.contribution)
        } else {
            cell.contribution.text = nil
        }
    }
}
