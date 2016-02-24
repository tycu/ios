import UIKit
import TTTAttributedLabel

class EventViewController: UIViewController {
    var event: Event!
    @IBOutlet weak var summary: MarkdownLabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        summary.presentMarkdown(event.summary)
    }
}
