import Stripe

class AddCardViewController : UIViewController, STPPaymentCardTextFieldDelegate {
    @IBOutlet weak var cardField: STPPaymentCardTextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        cardField.becomeFirstResponder()
        
        Analytics.track("enter_card")
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        navigationItem.rightBarButtonItem?.enabled = cardField.valid
    }
    
    private func lockUI() {
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = false
        cardField.enabled = false
        cardField.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()

    }
    
    private func unlockUI() {
        navigationItem.leftBarButtonItem?.enabled = true
        navigationItem.rightBarButtonItem?.enabled = true
        cardField.enabled = true
        cardField.hidden = false
        activityIndicator.hidden = true
    }
    
    func done() {
        lockUI()
        
        STPAPIClient.sharedClient().createTokenWithCard(cardField.cardParams, completion: { token, error in
            guard error == nil else  {
                showErrorDialogWithMessage("Unable to add card, please try again.", inViewController: self)
                self.unlockUI()
                return
            }
            
            if let token = token {
                var body = [String : AnyObject]()
                body["stripeKey"] = Stripe.defaultPublishableKey()!
                body["cardToken"] = token.tokenId
                
                Requests.post(Endpoints.setCard, withBody: body, completionHandler: { response, error in
                    if response?.statusCode == 200 {
                        Analytics.track("updated_card")
                        UserData.update({ succeeded in
                            self.next()
                        })
                    } else {
                        self.unlockUI()
                        
                        if let error = response?.body?["error"] as? [String : String] {
                            if let message = error["message"] {
                                showErrorDialogWithMessage(message, inViewController: self)
                                return
                            }
                        }
                        
                        showErrorDialogWithMessage("Unable to add card, please try again.", inViewController: self)
                    }
                })
            }
        })
    }
    
    func next() {
        if let parentViewController = parentViewController as? ContributionNavigationController {
            parentViewController.next()
        } else {
            dismiss()
        }
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
