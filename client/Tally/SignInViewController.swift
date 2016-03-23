import UIKit
import FBSDKLoginKit
import SSKeychain

class SignInViewController : UIViewController {
    @IBOutlet weak var facebook: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Keychain.clear()
        
        facebook.layer.cornerRadius = 2        
        facebook.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(authenticate)))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.navigationBar.barStyle = .Default
    }
    
    func authenticate() {
        FBSDKLoginManager().logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: { result, error in
            if (error != nil) {
                showErrorDialogWithMessage("Facebook login failed, please try again.", inViewController: self)
            } else if (result.isCancelled) {
            } else {
                if (result.grantedPermissions.contains("email")) {
                    self.facebook.hidden = true
                    self.indicator.hidden = false
                    
                    let body = ["facebookToken": FBSDKAccessToken.currentAccessToken().tokenString]
                    Requests.post(Endpoints.authenticate, withBody: body, completionHandler: { response, error in
                        if response?.statusCode == 200 {
                            if let token = response!.body?["accessToken"] as? String {
                                Keychain.setAccessToken(token)
                                UserData.update({ succeeded in
                                    if succeeded {
                                        self.next()
                                    } else {
                                        self.loginFailed()
                                    }
                                })
                                return
                            }
                        }
                        self.loginFailed()
                    })
                } else {
                    Keychain.clear()
                    showErrorDialogWithMessage("Permission to use your email address is required to sign in, please try again.", inViewController: self)
                }
            }
        })
    }
    
    private func loginFailed() {
        self.facebook.hidden = false
        self.indicator.hidden = true
        Keychain.clear()
        showErrorDialogWithMessage("Login failed, please try again.", inViewController: self)
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
