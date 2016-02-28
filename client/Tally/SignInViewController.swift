import UIKit
import FBSDKLoginKit

class SignInViewController : UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var facebook: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .Plain, target: self, action: "done")
        
        facebook.readPermissions = ["public_profile", "email", "user_friends"]
        facebook.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: NSError?) {
        guard error == nil && result != nil else {
            self.showErrorDialogWithMessage("Facebook login failed, please try again.")
            return
        }
        
        if !result!.isCancelled {
            if result!.grantedPermissions.contains("email") {
                let body = ["facebookAccessToken": FBSDKAccessToken.currentAccessToken().tokenString]
                Requests.post(Endpoints.tokens, withBody: body, completionHandler: { response, error in
                    if response?.statusCode == 200 {
                        self.done()
                    } else {
                        FBSDKLoginManager().logOut()
                        self.showErrorDialogWithMessage("Login failed, please try again.")
                    }
                })
            } else {
                FBSDKLoginManager().logOut()
                showErrorDialogWithMessage("Permission to access your email address is required to sign in, please try again.")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton) {
    }
    
    func done() {
        if let parentViewController = parentViewController as? ProfileViewController {
            parentViewController.swapContainerViewControllerTo(storyboard!.instantiateViewControllerWithIdentifier("SignedInViewController"))
        } else {
            dismissViewControllerAnimated(true, completion: {
                let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            })
        }
    }
    
    private func showErrorDialogWithMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
}
