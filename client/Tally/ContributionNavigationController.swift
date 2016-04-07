class ContributionNavigationController : UINavigationController {
    var event: Event!
    var inSupport: Bool!
    var selectedPac: Pac?
    var amount: Int?
    var steps = 1
    var currentStep = 0
    
    func prepareForEvent(event: Event, inSupport: Bool) {
        self.event = event
        self.inSupport = inSupport
        
        let pacs = inSupport == true ? event.supportPacs : event.opposePacs
        if pacs.count == 1 {
            selectedPac = pacs[0]
        }
        
        let needsPac = selectedPac == nil
        let needsCard = !UserData.instance!.chargeable
        let needsProfile = UserData.instance!.profile.occupation == nil || UserData.instance!.profile.employer == nil || UserData.instance!.profile.streetAddress == nil || UserData.instance!.profile.cityStateZip == nil
        
        if needsPac {
            steps += 1
        }
        if needsCard {
            steps += 1
        }
        if needsProfile {
            steps += 1
        }
        
        next()
    }
    
    func next() {
        if Keychain.getAccessToken() == nil {
            let signInViewController = storyboard!.instantiateViewControllerWithIdentifier("SignInViewController")
            let cancel = UIBarButtonItem(title: "Cancel", style: .Plain, target: signInViewController, action: #selector(SignInViewController.cancel))
            cancel.tintColor = UIColor.whiteColor()
            signInViewController.navigationItem.leftBarButtonItem = cancel
            navigationBar.translucent = true
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.shadowImage = UIImage()
            setViewControllers([signInViewController], animated: true)
            return
        }
        
        navigationBar.translucent = false
        navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        navigationBar.shadowImage = nil
        navigationBar.barStyle = .Default
        
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
        
        let needsPac = selectedPac == nil
        let needsCard = !UserData.instance!.chargeable
        let needsProfile = UserData.instance!.profile.occupation == nil || UserData.instance!.profile.employer == nil || UserData.instance!.profile.streetAddress == nil || UserData.instance!.profile.cityStateZip == nil
        
        currentStep += 1
        
        if needsPac {
            let pacs = inSupport == true ? event.supportPacs : event.opposePacs
            
            let pacsViewController = storyboard!.instantiateViewControllerWithIdentifier("PacsViewController") as! PacsViewController
            pacsViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: pacsViewController, action: #selector(PacsViewController.cancel))
            pacsViewController.event = event
            pacsViewController.pacs = pacs
            pacsViewController.inSupport = inSupport
            pacsViewController.title = "Step \(currentStep) of \(steps)"
            setViewControllers([pacsViewController], animated: true)
            return
        }
        
        if needsCard {
            let addCardViewController = storyboard!.instantiateViewControllerWithIdentifier("AddCardViewController")
            addCardViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: addCardViewController, action: #selector(AddCardViewController.cancel))
            addCardViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: addCardViewController, action: #selector(AddCardViewController.done))
            addCardViewController.navigationItem.rightBarButtonItem!.enabled = false
            addCardViewController.title = "Step 2 of \(steps)"
            setViewControllers([addCardViewController], animated: true)
            return
        }
        
        if needsProfile {
            let editProfileViewController = storyboard!.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
            editProfileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: editProfileViewController, action: #selector(EditProfileViewController.cancel))
            editProfileViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .Done, target: editProfileViewController, action: #selector(EditProfileViewController.done))
            editProfileViewController.required = true
            editProfileViewController.title = "Step \(currentStep) of \(steps)"
            setViewControllers([editProfileViewController], animated: true)
            return
        }
    
        if amount == nil {
            let contributeViewController = storyboard!.instantiateViewControllerWithIdentifier("ContributeViewController") as! ContributeViewController
            contributeViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: contributeViewController, action: #selector(ContributeViewController.cancel))
            contributeViewController.event = event
            contributeViewController.pac = selectedPac
            contributeViewController.inSupport = inSupport
            if steps > 1 {
                contributeViewController.title = "Step \(currentStep) of \(steps)"
            } else {
                contributeViewController.title = inSupport == true ? "Support" : "Oppose"
            }
            setViewControllers([contributeViewController], animated: true)
            return
        }
        
        let postDonateViewController = storyboard!.instantiateViewControllerWithIdentifier("PostContributeViewController") as! PostContributeViewController
        postDonateViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: postDonateViewController, action: #selector(PostContributeViewController.done))
        setViewControllers([postDonateViewController], animated: true)
    }
}
