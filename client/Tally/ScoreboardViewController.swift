class ScoreboardViewController : UITableViewController {
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var politicians = [Politician]()
    private var lastAppeared: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "All Time"
        navigationItem.backBarButtonItem = simpleBackButton()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
        
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = Colors.primary
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let lastAppeared = lastAppeared {
            if abs(Int(lastAppeared.timeIntervalSinceNow)) > 120 {
                refresh(refreshControl!)
            }
        } else {
            refresh(self)
        }
        
        lastAppeared = NSDate()
        
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return politicians.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let politician = politicians[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ScoreboardCell", forIndexPath: indexPath) as! ScoreboardCell
        
        politician.setThumbnail(cell.thumbnail)
        cell.name.text = politician.name
        cell.jobTitle.text = politician.jobTitle
        
        cell.position.text = "\(indexPath.row + 1)"
        
        cell.graph.politician = politician
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("PoliticianSegue", sender: politicians[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PoliticianSegue" {
            let eventsViewController = segue.destinationViewController as! EventsViewController
            eventsViewController.politician = (sender as! Politician)
        }
    }
    
    func refresh(sender: AnyObject) {
        if sender is EventsViewController && politicians.count > 0 {
            return
        }
        
        tableView.backgroundView = activityIndicator
        
        Requests.get(Endpoints.allTimeScoreboard, completionHandler: { response, error in
            self.refreshControl!.endRefreshing()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.tableView.backgroundView = nil
                
                self.politicians.removeAll()
                
                if response?.statusCode == 200 {
                    if let politicians = response!.body!["politicians"] as? [[String : AnyObject]] {
                        for politician in politicians {
                            do {
                                self.politicians.append(try Politician(data: politician))
                            } catch _ {
                                p("Skipping invalid politician")
                            }
                        }
                    }
                    
                    if self.politicians.count == 0 {
                        // Set empty state
                    }
                } else {
                    // Something bad happened, set error empty state
                }
                
                self.tableView.reloadData()
            }
        })
    }
}
