import UIKit

class ProfileViewController : UIViewController {
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Keychain.getAccessToken() == nil {
            let signInViewController = storyboard!.instantiateViewControllerWithIdentifier("SignInViewController")
            swapContainerViewControllerTo(signInViewController)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController!.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = nil
    }
        
    func swapContainerViewControllerTo(newViewController: UIViewController) {
        let currentViewController = childViewControllers.first!
        
        currentViewController.view.removeFromSuperview()
        currentViewController.removeFromParentViewController()
        currentViewController.didMoveToParentViewController(self)

        addChildViewController(newViewController)
        newViewController.view.frame = container.bounds
        container.addSubview(newViewController.view)
        newViewController.didMoveToParentViewController(self)
        newViewController.beginAppearanceTransition(true, animated: true)
    }
}
