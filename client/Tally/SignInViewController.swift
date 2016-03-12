import UIKit
import FBSDKLoginKit
import SSKeychain

class SignInViewController : UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var facebook: FBSDKLoginButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Keychain.clear()
        
        facebook.readPermissions = ["public_profile", "email", "user_friends"]
        facebook.delegate = self
    }
    
    func loginButton(loginButton: FBSDKLoginButton, didCompleteWithResult result: FBSDKLoginManagerLoginResult?, error: NSError?) {
        guard error == nil && result != nil else {
            showErrorDialogWithMessage("Facebook login failed, please try again.", inViewController: self)
            return
        }
        
        if !result!.isCancelled {
            if result!.grantedPermissions.contains("email") {
                let body = ["facebookToken": FBSDKAccessToken.currentAccessToken().tokenString]
                Requests.post(Endpoints.authenticate, withBody: body, completionHandler: { response, error in
                    if response?.statusCode == 200 {
                        if let token = response!.body?["accessToken"] as? String {
                            Keychain.setAccessToken(token)
                            UserData.update({ succeeded in
                                self.next()
                            })
                            return
                        }
                    }
                    
                    Keychain.clear()
                    showErrorDialogWithMessage("Login failed, please try again.", inViewController: self)
                })
            } else {
                Keychain.clear()
                showErrorDialogWithMessage("Permission to access your email address is required to sign in, please try again.", inViewController: self)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton) {
    }
    
    func next() {
        if let parentViewController = parentViewController as? ProfileViewController {
            parentViewController.swapContainerViewControllerTo(storyboard!.instantiateViewControllerWithIdentifier("SignedInViewController"))
        } else if let parentViewController = parentViewController as? ContributionNavigationController {
            parentViewController.next()
        } else {
            dismiss()
        }
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        dismissViewControllerAnimated(true, completion: {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        })
    }
}
