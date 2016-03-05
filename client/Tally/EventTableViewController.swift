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
            donation.setLabel(cell.contribution)
        } else {
            cell.contribution.text = nil
        }
        
        event.politician.setThumbnail(cell.thumbnail)
        cell.headline.presentMarkdown(event.headline)
        cell.graph.supportTotal = event.supportTotal
        cell.graph.opposeTotal = event.opposeTotal
        cell.time.text = event.created.humanReadableTimeSinceNow
    }
}
