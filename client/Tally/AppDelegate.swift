import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
        let navigationController = NavigationController(rootViewController: viewController)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        return true
    }
}
