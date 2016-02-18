import UIKit

class StoryViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
    }
}
