class MainViewController : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if selectedIndex == 0 {
            Analytics.track("tab_selected", properties: ["tab": "events"])
        } else if selectedIndex == 1 {
            Analytics.track("tab_selected", properties: ["tab": "scoreboard"])
        } else if selectedIndex == 2 {
            Analytics.track("tab_selected", properties: ["tab": "profile"])
        }
    }
}
