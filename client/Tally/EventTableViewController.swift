import UIKit
import SDWebImage

class EventTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 338
        tableView.registerNib(UINib(nibName: "EventCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "EventCell")
    }
    
    func prepareCell(cell: EventCell, forEvent event: Event, showingPicture: Bool, showingButtons: Bool) {
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
            cell.picture.sd_setImageWithURL(NSURL(string: event.imageUrl! + "?w=818&fit=crop"))
        } else {
            cell.pictureHeight.constant = 0
            cell.pictureTopSpace.constant = 2
            cell.pictureBottomSpace.constant = 0
        }
        
        cell.contentView.userInteractionEnabled = false

        cell.graph.event = event
        
        cell.oppose.layer.borderColor = Colors.secondary.CGColor
        cell.oppose.layer.borderWidth = 1
        cell.oppose.layer.cornerRadius = 6
        cell.oppose.tintColor = Colors.secondary
        cell.oppose.addTarget(self, action: #selector(oppose(_:)), forControlEvents: .TouchUpInside)
        
        cell.support.layer.borderColor = Colors.secondary.CGColor
        cell.support.layer.borderWidth = 1
        cell.support.layer.cornerRadius = 6
        cell.support.tintColor = Colors.secondary
        cell.support.addTarget(self, action: #selector(support(_:)), forControlEvents: .TouchUpInside)
        
        if showingButtons {
            cell.buttonsHolder.hidden = false
        } else {
            cell.buttonsHolder.hidden = true
        }
        
        if let contribution = UserData.instance?.eventIdenToContribution[event.iden] {
            contribution.setLabel(cell.contribution)
            cell.buttonsHolder.hidden = true
        } else {
            cell.contribution.text = nil
        }
    }
    
    func oppose(sender: UIButton) {
    }
    
    func support(sender: UIButton) {
    }
}
