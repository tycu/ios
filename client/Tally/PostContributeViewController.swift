class PostContributeViewController : UIViewController {
    
    func done() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}