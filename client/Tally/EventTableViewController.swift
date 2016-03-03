import UIKit
import SDWebImage

class EventTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        tableView.registerNib(UINib(nibName: "EventCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "EventCell")
    }
    
    func prepareCell(cell: EventCell, forEvent event: Event) {
        if let donation = UserData.instance?.eventIdenToDonation[event.iden] {
            if (CGFloat(Float(arc4random()) /  Float(UInt32.max)) > 0.5) {
                cell.contribution.textColor = Colors.support
                cell.contribution.text = "Supported ($5)"
            } else {
                cell.contribution.textColor = Colors.oppose
                cell.contribution.text = "Opposed ($5)"
            }
        } else {
            cell.contribution.text = nil
        }
        
        event.politician.setThumbnail(cell.thumbnail)
        cell.headline.presentMarkdown(event.headline)
        cell.graph.event = event
        cell.time.text = event.created.humanReadableTimeSinceNow
    }
}
