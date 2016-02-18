import UIKit

class StoryViewController: UIViewController {
    var story: Story!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
}
