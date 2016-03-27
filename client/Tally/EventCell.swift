import UIKit

class EventCell : UITableViewCell {
    @IBOutlet weak var contribution: UILabel!
    @IBOutlet weak var headline: MarkdownLabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var pictureHeight: NSLayoutConstraint!
    @IBOutlet weak var graph: SupportOpposeView!
}
