class SignedInViewController : EventTableViewController {
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var profileHolder: UIStackView!
    @IBOutlet weak var profilePictureHolder: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupationImage: UIImageView!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var optionsHolder: UIView!
    @IBOutlet weak var cardHolder: TouchStateView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureHolder.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureHolder.layer.borderWidth = 2
        profilePictureHolder.layer.cornerRadius = profilePictureHolder.bounds.width / 2
        profilePictureHolder.layer.masksToBounds = true
        
        occupationImage.tintColor = UIColor.whiteColor()
        addressImage.tintColor = occupationImage.tintColor
        
        cardHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "editCard"))
        
        cardImage.tintColor = UIColor.whiteColor()
        cardImage.layer.cornerRadius = 6
        cardImage.layer.masksToBounds = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        
        EventBus.register(self, forEvent: "user_data_changed", withHandler: { data in
            self.update()
            self.tableView.reloadData()
        })
        
        update()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.navigationBar.barStyle = .Default
        
        EventBus.unregister(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.instance?.donations.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = UserData.instance!.donations[indexPath.row].event
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        prepareCell(cell, forEvent: event)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("EventSegue", sender: UserData.instance!.donations[indexPath.row].event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCardSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let addCardViewController = navigationController.childViewControllers[0]
            addCardViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: addCardViewController, action: "cancel")
            addCardViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: addCardViewController, action: "done")
            addCardViewController.navigationItem.rightBarButtonItem!.enabled = false
        } else if segue.identifier == "EventSegue" {
            let eventViewController = segue.destinationViewController as! EventViewController
            eventViewController.event = sender as! Event
        }
    }
    
    private func update() {
        if let userData = UserData.instance {
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editProfile")
            editButton.tintColor = UIColor.whiteColor()
            navigationController!.navigationBar.topItem!.rightBarButtonItem = editButton
            
            userData.profile.setThumbnail(profilePicture)
            name.text = userData.profile.name
            
            occupation.text = ""
            if let job = userData.profile.occupation {
                occupation.layer.opacity = 1
                occupation.text! += "\(job) "
            } else {
                occupation.layer.opacity = 0.6
                occupation.text = "Occupation"
            }
            
            if let employer = userData.profile.employer {
                occupation.text! += "@ \(employer)"
            }
            
            if userData.profile.streetAddress != nil || userData.profile.cityStateZip != nil {
                occupation.layer.opacity = 1
                address.text = [userData.profile.streetAddress ?? "", userData.profile.cityStateZip ?? ""].joinWithSeparator("\n")
            } else {
                address.layer.opacity = 0.6
                address.text = "Address"
            }
            
            if userData.chargeable {
                cardLabel.text = "Update card"
            } else {
                cardLabel.text = "Add card"
            }
            
            profileHolder.hidden = false
            optionsHolder.hidden = false
            indicator.hidden = true
        } else {
            profileHolder.hidden = true
            optionsHolder.hidden = true
            indicator.hidden = false
        }
        
        tableView.reloadData()
    }
    
    func editProfile() {
        performSegueWithIdentifier("EditProfileSegue", sender: nil)
    }
    
    func editCard() {
        performSegueWithIdentifier("AddCardSegue", sender: nil)
    }
}
