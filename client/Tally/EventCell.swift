import UIKit

class EventCell : UITableViewCell {
    @IBOutlet weak var contribution: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var headline: MarkdownLabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var graph: SupportOpposeView!
    
    override func awakeAfterUsingCoder(aDecoder: NSCoder) -> AnyObject? {
        // without this check you'll end up with a recursive loop - we need to know that we were loaded from our view xib vs the storyboard.
        // set the view tag in the MyView xib to be -999 and anything else in the storyboard.
        if ( self.tag == -999 )
        {
            return self;
        }
        
        let eventCell = UINib(nibName: "EventCell", bundle: NSBundle.mainBundle()).instantiateWithOwner(nil, options: nil)[0] as! EventCell
        eventCell.frame = frame
        eventCell.autoresizingMask = autoresizingMask
        eventCell.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        eventCell.tag = tag
        
        return eventCell
    }
}
