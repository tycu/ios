class DonateViewController : UIViewController {
    var event: Event!
    var pac: Pac!
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
