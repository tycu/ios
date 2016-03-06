class PacsViewController : UITableViewController {
    var pacs: [Pac]!
    var inSupport: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = simpleBackButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if inSupport == true {
            navigationItem.title = "Support"
        } else {
            navigationItem.title = "Oppose"
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pacs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pac = pacs[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PacCell", forIndexPath: indexPath) as! PacCell
        cell.name.text = pac.name
        cell.summary.text = pac.summary
        
        cell.color.layer.cornerRadius = cell.color.bounds.width / 2
        cell.color.layer.masksToBounds = true
        cell.color.backgroundColor = nil
        if let color = pac.color {
            if color == "blue" {
                cell.color.backgroundColor = Colors.democrat
            } else if color == "red" {
                cell.color.backgroundColor = Colors.republican
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let donationNavigationController = parentViewController as! DonationNavigationController
        donationNavigationController.selectedPac = pacs[indexPath.row]
        donationNavigationController.next()
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
