import FBSDKShareKit

class SignedInViewController : EventTableViewController, FBSDKAppInviteDialogDelegate {
    @IBOutlet weak var header: UIView!
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
    @IBOutlet weak var inviteHolder: TouchStateView!
    @IBOutlet weak var inviteImage: UIImageView!
    @IBOutlet weak var contributions: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = Colors.primary
        refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: .ValueChanged)
        
        header.backgroundColor = Colors.primary
        
        profilePictureHolder.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureHolder.layer.borderWidth = 3
        profilePictureHolder.layer.cornerRadius = profilePictureHolder.bounds.width / 2
        profilePictureHolder.layer.masksToBounds = true
        
        occupationImage.tintColor = UIColor.whiteColor()
        addressImage.tintColor = occupationImage.tintColor
        
        cardHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editCard)))
        
        cardImage.tintColor = UIColor.whiteColor()
        cardImage.layer.cornerRadius = 6
        cardImage.layer.masksToBounds = true
        
        inviteHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriends)))
        
        inviteImage.tintColor = UIColor.whiteColor()
        inviteImage.layer.cornerRadius = 6
        inviteImage.layer.masksToBounds = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.barStyle = .Black
        
        EventBus.register(self, forEvent: "user_data_changed", withHandler: { data in
            self.update()
            self.tableView.reloadData()
        })
        
        update()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.translucent = false
        navigationController!.navigationBar.barStyle = .Default
        
        EventBus.unregister(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserData.instance?.contributions.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = UserData.instance!.contributions[indexPath.row].event
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        prepareCell(cell, forEvent: event)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("EventSegue", sender: UserData.instance!.contributions[indexPath.row].event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddCardSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let addCardViewController = navigationController.childViewControllers[0]
            addCardViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: addCardViewController, action: #selector(AddCardViewController.cancel))
            addCardViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: addCardViewController, action: #selector(AddCardViewController.done))
            addCardViewController.navigationItem.rightBarButtonItem!.enabled = false
        } else if segue.identifier == "EditProfileSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let editProfileViewController = navigationController.childViewControllers[0]
            editProfileViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: editProfileViewController, action: #selector(EditProfileViewController.done))
            editProfileViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: editProfileViewController, action: #selector(EditProfileViewController.cancel))
        } else if segue.identifier == "EventSegue" {
            let eventViewController = segue.destinationViewController as! EventViewController
            eventViewController.event = sender as! Event
        }
    }
    
    func refresh(sender: AnyObject) {
        UserData.update({ succeeded in
            self.refreshControl!.endRefreshing()
        })
    }
    
    private func update() {
        if let userData = UserData.instance {
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(editProfile))
            editButton.tintColor = UIColor.whiteColor()
            navigationController!.navigationBar.topItem!.rightBarButtonItem = editButton
            
            userData.profile.setThumbnail(profilePicture)
            name.text = userData.profile.name
            
            if userData.profile.occupation != nil || userData.profile.cityStateZip != nil {
                occupation.layer.opacity = 1
                occupation.text! = [userData.profile.occupation ?? "", userData.profile.employer ?? ""].joinWithSeparator(" @ ")
            } else {
                occupation.layer.opacity = 0.6
                occupation.text = "Occupation"
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
            
            contributions.text = userData.contributions.count == 0 ? "Contributions (none yet)" : "Contributions"
            
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
    
    func inviteFriends() {
        let content = FBSDKAppInviteContent()
        content.appLinkURL = NSURL(string: "https://fb.me/1030420230374246")!
        content.appInvitePreviewImageURL = NSURL(string: "https://static.tally.us/images/kot9xqqdeq6ez5mis1621t1zhqwipb9.png")!
        
        FBSDKAppInviteDialog.showFromViewController(self, withContent: content, delegate: self)
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
    }
}
