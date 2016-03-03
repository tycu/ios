class SignedInViewController : EventTableViewController {
    @IBOutlet weak var profileHolder: UIStackView!
    @IBOutlet weak var profilePictureHolder: UIView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var occupationImage: UIImageView!
    @IBOutlet weak var occupation: UILabel!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var cardHolder: TouchStateView!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileHolder.hidden = true
        
        profilePictureHolder.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureHolder.layer.borderWidth = 2
        profilePictureHolder.layer.cornerRadius = profilePictureHolder.bounds.width / 2
        profilePictureHolder.layer.masksToBounds = true
        
        occupationImage.tintColor = UIColor.whiteColor()
        addressImage.tintColor = occupationImage.tintColor
        
        cardImage.tintColor = UIColor.whiteColor()
        cardImage.layer.cornerRadius = 6
        cardImage.layer.masksToBounds = true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barStyle = .Black
        
        profilePicture.sd_setImageWithURL(NSURL(string: "https://graph.facebook.com/1682662308683021/picture?type=large")!)
        
        name.text = "Ryan Oldenburg"
        occupation.text = "Software Engineer @ Hipmunk"
        address.text = "508 Octavia St #6\nSan Francisco, CA 94102"
        
        profileHolder.hidden = false
        profileHolder.alpha = 0
        UIView.animateWithDuration(0.3, animations: {
            self.profileHolder.alpha = 1
        })
        
        cardHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "editCard"))
        cardLabel.text = "Update card"
        
        let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editProfile")
        editButton.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.topItem!.rightBarButtonItem = editButton
        
        Requests.get(Endpoints.recentEvents, completionHandler: { response, error in
            self.events.removeAll()
            
            if response?.statusCode == 200 {
                if let stories = response!.body!["events"] as? [[String : AnyObject]] {
                    for story in stories {
                        do {
                            self.events.append(try Event(data: story))
                        } catch _ {
                            p("Skipping invalid event")
                        }
                    }
                }
                
                self.tableView.backgroundView = nil
            } else {
                // Something bad happened
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController!.navigationBar.barStyle = .Default
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        prepareCell(cell, forEvent: event)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("EventSegue", sender: events[indexPath.row])
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
    
    func editProfile() {
    }
    
    func editCard() {
        performSegueWithIdentifier("AddCardSegue", sender: nil)
    }
}
