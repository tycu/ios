class PacsViewController : UITableViewController {
    var event: Event!
    var options: [Pac]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = simpleBackButton()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let pac = options[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PacCell", forIndexPath: indexPath) as! PacCell
        cell.name.text = pac.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("DonateSegue", sender: options[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DonateSegue" {
            let donateViewController = segue.destinationViewController as! DonateViewController
            donateViewController.event = event
            donateViewController.pac = sender as! Pac
        }
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
