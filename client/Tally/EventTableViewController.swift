import UIKit
import SDWebImage

class EventTableViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 338
        tableView.registerNib(UINib(nibName: "EventCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "EventCell")
    }
    
    func prepareCell(cell: EventCell, forEvent event: Event) {
        cell.pictureIndicator.startAnimating()
        
        cell.note.text = nil
        
        cell.headline.text = event.headline
        
        // Increase the line height of the headline
        let headlineAttributedString = NSMutableAttributedString(attributedString: cell.headline.attributedText!)
        let headlineParagraphStyle = NSMutableParagraphStyle()
        headlineParagraphStyle.lineSpacing = 2
        headlineAttributedString.addAttribute(NSParagraphStyleAttributeName, value: headlineParagraphStyle, range: NSMakeRange(0, headlineAttributedString.length))
        cell.headline.attributedText = headlineAttributedString
        
        cell.time.text = event.created.humanReadableTimeSinceNow
        
        if event.imageUrl != nil {
            cell.picture.layer.cornerRadius = 6
            cell.picture.sd_setImageWithURL(NSURL(string: event.imageUrl! + "?w=818&fit=crop"))
        } else {
            cell.pictureIndicator.hidden = true
            cell.pictureHeight.constant = 0
            cell.pictureTopSpace.constant = 2
            cell.pictureBottomSpace.constant = 0
        }
        
        cell.contentView.userInteractionEnabled = false

        cell.graph.event = event
        
        cell.oppose.hidden = false
        cell.oppose.setTitle("Oppose", forState: .Normal)
        cell.oppose.layer.borderColor = Colors.support.CGColor
        cell.oppose.backgroundColor = nil
        cell.oppose.layer.borderWidth = 1
        cell.oppose.layer.cornerRadius = 6
        cell.oppose.tintColor = Colors.support
        cell.oppose.removeTarget(self, action: nil, forControlEvents: .AllEvents)
        
        cell.support.hidden = false
        cell.support.setTitle("Support", forState: .Normal)
        cell.support.layer.borderColor = Colors.support.CGColor
        cell.support.backgroundColor = nil
        cell.support.layer.borderWidth = 1
        cell.support.layer.cornerRadius = 6
        cell.support.tintColor = Colors.support
        cell.support.removeTarget(self, action: nil, forControlEvents: .AllEvents)
        
        if let contribution = UserData.instance?.eventIdenToContribution[event.iden] {
            let filled: UIButton, disabled: UIButton
            if contribution.support {
                filled = cell.support
                disabled = cell.oppose
                
                filled.backgroundColor = Colors.support
                filled.setTitle("Support ($\(contribution.amount))", forState: .Normal)
            } else {
                filled = cell.oppose
                disabled = cell.support
                
                filled.backgroundColor = Colors.oppose
                filled.setTitle("Oppose ($\(contribution.amount))", forState: .Normal)
            }
            
            filled.layer.borderWidth = 0
            filled.tintColor = UIColor.whiteColor()
            
            disabled.layer.borderColor = Colors.divider.CGColor
            disabled.tintColor = Colors.divider
        } else {
            if event.opposePacs.count > 0 {
                cell.oppose.addTarget(self, action: #selector(oppose(_:)), forControlEvents: .TouchUpInside)
            } else {
                cell.oppose.hidden = true
            }
        
            if event.supportPacs.count > 0 {
                cell.support.addTarget(self, action: #selector(support(_:)), forControlEvents: .TouchUpInside)
            } else {
                cell.support.hidden = true
            }
        }
    }
    
    func oppose(sender: UIButton) {
    }
    
    func support(sender: UIButton) {
    }
}
