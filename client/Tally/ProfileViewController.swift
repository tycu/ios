import UIKit

class ProfileViewController : UIViewController {
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Tally"
        
        let signInViewController = storyboard!.instantiateViewControllerWithIdentifier("SignInViewController")
        swapContainerViewControllerTo(signInViewController)
    }
    
    func swapContainerViewControllerTo(newViewController: UIViewController) {
        let currentViewController = childViewControllers.first!
        
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParentViewController()
        currentViewController.didMoveToParentViewController(self)
        
        addChildViewController(newViewController)
        newViewController.didMoveToParentViewController(self)
        newViewController.view.frame = container.bounds
        container.addSubview(newViewController.view)
    }
}
