import UIKit

class SignInViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: "skip")
    }
    
    func skip() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
