class PacsViewController : UITableViewController {
    @IBOutlet weak var heading: UILabel!
    var event: Event!
    var pacs: [Pac]!
    var inSupport: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = simpleBackButton()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        heading.text = "Where would you like to contribute in" + (inSupport == true ? " support of " : " opposition to ") + event.politician.name + "?"
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
        
        let contributionNavigationController = parentViewController as! ContributionNavigationController
        contributionNavigationController.selectedPac = pacs[indexPath.row]
        contributionNavigationController.next()
    }
    
    func cancel() {
        dismiss()
    }
    
    private func dismiss() {
        navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
}
