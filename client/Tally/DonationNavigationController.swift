class DonationNavigationController : UINavigationController {
    var queue = [UIViewController]()
    
    func next() {
        setViewControllers([queue.removeFirst()], animated: true)
    }
}
