import UIKit
import SSKeychain
import Stripe
import Social

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GGLInstanceIDDelegate {
    var window: UIWindow?
    private var lastActive: NSDate?
    private var notificationEventIden: String?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        SSKeychain.setAccessibilityType(kSecAttrAccessibleAfterFirstUnlock)
        Stripe.setDefaultPublishableKey("pk_test_Cp9lEtzreLcuDVH4IFE6RVhD")
        GCMService.sharedInstance().startWithConfig(GCMConfig.defaultConfig())
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.tintColor = Colors.primary
        window!.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window!.makeKeyAndVisible()
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        checkLastVersion()
        return true
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        FBSDKAppEvents.activateApp()
        
        if let lastActive = lastActive {
            if abs(Int(lastActive.timeIntervalSinceNow)) > 120 {
                UserData.update(nil)
            }
        }
        
        if let eventIden = notificationEventIden {
            if let tabBarController = window!.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 0
                let navigationController = tabBarController.selectedViewController! as! UINavigationController
                
                let selectEvent = {
                    let eventsViewController = navigationController.viewControllers[0] as! EventsViewController
                    eventsViewController.segmentedControl.selectedSegmentIndex = 0
                    eventsViewController.notificationEventIden = eventIden
                    eventsViewController.refresh(eventsViewController.refreshControl!)
                }
                
                if navigationController.viewControllers.count > 1 {
                    navigationController.popToRootViewControllerAnimated(true)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                        selectEvent()
                    }
                } else {
                    selectEvent()
                }
            }
        }
        
        lastActive = NSDate()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let sandbox: Bool
        #if DEBUG
            sandbox = true
        #else
            sandbox = false
        #endif
        
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity("229659126485", scope: kGGLInstanceIDScopeGCM, options: [kGGLInstanceIDRegisterAPNSOption: deviceToken, kGGLInstanceIDAPNSServerTypeSandboxOption: sandbox], handler: { token, error in
            GCMPubSub.sharedInstance().subscribeWithToken(token, topic: "/topics/broadcasts", options: nil, handler: { error in
                if error == nil || error.code == 3001 {
                    p("Subscribed to broadcasts")
                }
            })
        })
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        GCMService.sharedInstance().appDidReceiveMessage(userInfo)
        
        if (UIApplication.sharedApplication().applicationState == .Inactive) {
            if let eventIden = userInfo["event"] as? String {
                p("Opening app for event \(eventIden)")
                notificationEventIden = eventIden
            }
        }
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func onTokenRefresh() {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    private func checkLastVersion() {
//        let lastVersion = NSUserDefaults.standardUserDefaults().objectForKey("lastVersion") as? String
//        let version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
//        if (version != lastVersion) {
//            Keychain.clear()
//            
//            NSUserDefaults.standardUserDefaults().setValue(version, forKey: "lastVersion")
//            NSUserDefaults.standardUserDefaults().synchronize()
//            
//            if (lastVersion == nil) {
                let signInNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SignInNavigationController") as! UINavigationController
                signInNavigationController.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
                signInNavigationController.navigationBar.shadowImage = UIImage()
                let signInViewController = signInNavigationController.childViewControllers[0]
                let skip = UIBarButtonItem(title: "Skip", style: .Done, target: signInViewController, action: #selector(SignInViewController.cancel))
                skip.tintColor = UIColor.whiteColor()
                signInViewController.navigationItem.rightBarButtonItem = skip
                window!.rootViewController!.presentViewController(signInNavigationController, animated: true, completion: nil)
//                return
//            }
//        }
//        
//        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
//        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    }
}
