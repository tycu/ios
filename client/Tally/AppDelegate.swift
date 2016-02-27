import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
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
            NSUserDefaults.standardUserDefaults().setValue(version, forKey: "lastVersion")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            if (lastVersion == nil) {
                let signInViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignInNavigationController")
                window!.rootViewController!.presentViewController(signInViewController, animated: true, completion: nil)
                return
            }
        }
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
}
