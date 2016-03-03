class DonateViewController : UIViewController {
    var event: Event!
    var pac: Pac!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contribute"
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
