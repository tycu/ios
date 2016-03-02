import UIKit
import SSKeychain
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        SSKeychain.setAccessibilityType(kSecAttrAccessibleAfterFirstUnlock)
        Stripe.setDefaultPublishableKey("pk_test_Cp9lEtzreLcuDVH4IFE6RVhD")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.tintColor = Colors.purple
        window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
        window!.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        checkLastVersion()
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        p(deviceToken)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    private func checkLastVersion() {
        let lastVersion = NSUserDefaults.standardUserDefaults().objectForKey("lastVersion") as? String
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        if (version != lastVersion) {
            Keychain.clear()
            
            NSUserDefaults.standardUserDefaults().setValue(version, forKey: "lastVersion")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if (lastVersion == nil) {
                let signInNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignInNavigationController") as! UINavigationController
                signInNavigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
                signInNavigationController.navigationBar.shadowImage = UIImage()
                let signInViewController = signInNavigationController.childViewControllers[0]
                let skip = UIBarButtonItem(title: "Skip", style: .Done, target: signInViewController, action: "dismiss")
                skip.tintColor = UIColor.whiteColor()
                signInViewController.navigationItem.rightBarButtonItem = skip
                window!.rootViewController!.presentViewController(signInNavigationController, animated: true, completion: nil)
                return
            }
        }
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
}
