class DonateViewController : UIViewController {
    @IBOutlet var donate: UIButton!
    var event: Event!
    var pac: Pac!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contribute"
        
        donate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "donate:"))
    }
    
    func donate(sender: AnyObject) {
        var body = [String : AnyObject]()
        body["eventIden"] = event.iden
        body["pacIden"] = pac.iden
        body["amount"] = 5
        
        Requests.post(Endpoints.createDonation, withBody: body, completionHandler: { response, error in
            UserData.update({ succeeded in
                self.dismiss()
            })
        })
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
