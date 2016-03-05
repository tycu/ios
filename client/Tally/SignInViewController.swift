import UIKit
import FBSDKLoginKit
import SSKeychain

class SignInViewController : UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var facebook: FBSDKLoginButton!
    @IBOutlet weak var long: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Keychain.clear()
        
        tagline.font = UIFont(name: "Times New Roman", size: tagline.font!.pointSize)!
        
        card.layer.masksToBounds = false;
        card.layer.shadowColor = UIColor.blackColor().CGColor
        card.layer.shadowOffset = CGSizeMake(0, 1);
        card.layer.shadowOpacity = 0.4;
        card.layer.shadowRadius = 1.5;
        
        facebook.readPermissions = ["public_profile", "email", "user_friends"]
        facebook.delegate = self
        
        long.font = UIFont(name: "Times New Roman", size: long.font!.pointSize)!
        
        let attributedLong = NSMutableAttributedString(string: long.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedLong.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, long.text!.characters.count))
        long.attributedText = attributedLong
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
                                print("nnnnNNN")
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
        } else if let parentViewController = parentViewController as? DonationNavigationController {
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
