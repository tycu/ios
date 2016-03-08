class DonationNavigationController : UINavigationController {
    var event: Event!
    var inSupport: Bool!
    var selectedPac: Pac?
    var amount: Int?
    
    func prepareForEvent(event: Event, inSupport: Bool) {
        self.event = event
        self.inSupport = inSupport
        
        next()
    }
    
    func next() {
        if Keychain.getAccessToken() == nil {
            let signInViewController = storyboard!.instantiateViewControllerWithIdentifier("SignInViewController")
            signInViewController.navigationItem.title = "Log In"
            signInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: signInViewController, action: "cancel")
            setViewControllers([signInViewController], animated: true)
            return
        }
        
        if selectedPac == nil {
            let pacs = inSupport == true ? event.supportPacs : event.opposePacs
//            if pacs.count == 1 {
//                selectedPac = pacs[0]
//                next()
//            } else {
                let pacsViewController = storyboard!.instantiateViewControllerWithIdentifier("PacsViewController") as! PacsViewController
                pacsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: pacsViewController, action: "cancel")
                pacsViewController.navigationItem.title = "Contribution Options"
                pacsViewController.pacs = pacs
                pacsViewController.inSupport = inSupport
                setViewControllers([pacsViewController], animated: true)
//            }
            return
        }
        
        if UserData.instance == nil {
            UserData.update({ succeeded in
                if succeeded {
                    self.next()
                } else {
                    showErrorDialogWithMessage("Unable to get account information, please try again.", inViewController: self)
                }
            })
            return
        }
        
        if !UserData.instance!.chargeable {
            let addCardViewController = storyboard!.instantiateViewControllerWithIdentifier("AddCardViewController")
            addCardViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: addCardViewController, action: "cancel")
            addCardViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: addCardViewController, action: "done")
            addCardViewController.navigationItem.rightBarButtonItem!.enabled = false
            setViewControllers([addCardViewController], animated: true)
            return
        }
        
//        if UserData.instance!.profile.occupation == nil || UserData.instance!.profile.employer == nil || UserData.instance!.profile.streetAddress == nil || UserData.instance!.profile.cityStateZip == nil {
            let editProfileViewController = storyboard!.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
            editProfileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: editProfileViewController, action: "cancel")
            editProfileViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: editProfileViewController, action: "done")
            editProfileViewController.required = true
            setViewControllers([editProfileViewController], animated: true)
            return
//        }
        
        if amount == nil {
            let donateViewController = storyboard!.instantiateViewControllerWithIdentifier("DonateViewController") as! DonateViewController
            donateViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: donateViewController, action: "cancel")
            donateViewController.event = event
            donateViewController.pac = selectedPac
            donateViewController.inSupport = inSupport
            setViewControllers([donateViewController], animated: true)
            return
        }
        
        let postDonateViewController = storyboard!.instantiateViewControllerWithIdentifier("PostDonateViewController") as! PostDonateViewController
        postDonateViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: postDonateViewController, action: "done")
        setViewControllers([postDonateViewController], animated: true)
    }
}
