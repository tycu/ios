import UIKit

class EventCell : UITableViewCell {
    @IBOutlet weak var contribution: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var headline: MarkdownLabel!
    @IBOutlet weak var time: UILabel!
}
