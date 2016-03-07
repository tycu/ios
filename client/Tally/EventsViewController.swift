import UIKit
import SDWebImage

class EventsViewController : EventTableViewController {
    private let segmentedControl = UISegmentedControl(items: ["Recent", "Top"])
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var events = [Sort : [Event]]()
    var politician: Politician?
    private var lastAppeared: NSDate?
    
    private var activeSort: Sort {
        return segmentedControl.selectedSegmentIndex == 0 ? .Recent : .Top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = simpleBackButton()
        
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = Colors.primary
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 180, height: segmentedControl.frame.height)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentIndexSelected:", forControlEvents: .ValueChanged)
        
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if politician == nil {
            navigationItem.titleView = segmentedControl
        } else {
            navigationItem.title = politician!.name
        }
        
        if let lastAppeared = lastAppeared {
            if abs(Int(lastAppeared.timeIntervalSinceNow)) > 120 {
                refresh(refreshControl!)
            }
        } else {
            refresh(self)
        }
        
        lastAppeared = NSDate()
        
        EventBus.register(self, forEvent: "user_data_changed", withHandler: { data in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        EventBus.unregister(self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events[activeSort]?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = events[activeSort]![indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        prepareCell(cell, withEvent: event)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("EventSegue", sender: events[activeSort]![indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventSegue" {
            let eventViewController = segue.destinationViewController as! EventViewController
            eventViewController.event = sender as! Event
            eventViewController.hidePolitician = politician != nil
        }
    }
    
    func segmentIndexSelected(sender: UISegmentedControl) {
        tableView.backgroundView = nil
        tableView.reloadData()
        refresh(self)
    }
    
    func refresh(sender: AnyObject) {
        if sender is EventsViewController && events[activeSort] != nil {
            tableView.reloadData()
            return
        }
        
        if UserData.instance == nil {
            UserData.update(nil)
        }
        
        tableView.backgroundView = activityIndicator
        
        let sort = activeSort
        let url = sort == .Top ? Endpoints.topEvents : Endpoints.recentEvents
        Requests.get(url, completionHandler: { response, error in
            self.refreshControl!.endRefreshing()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.tableView.backgroundView = nil
                
                self.events[sort]?.removeAll()
                
                if response?.statusCode == 200 {
                    self.events[sort] = [Event]()
                    if let events = response!.body!["events"] as? [[String : AnyObject]] {
                        for event in events {
                            do {
                                let event = try Event(data: event)
                                if self.politician == nil || self.politician!.iden == event.politician?.iden {
                                    self.events[sort]!.append(event)
                                }
                            } catch _ {
                                p("Skipping invalid event")
                            }
                        }
                    }
                    
                    if self.events[sort]!.count == 0 {
                        self.tableView.backgroundView = NSBundle.mainBundle().loadNibNamed("EmptyStateView", owner: self, options: nil)[0] as! EmptyStateView
                    }
                } else {
                    let emptyStateView = NSBundle.mainBundle().loadNibNamed("EmptyStateView", owner: self, options: nil)[0] as! EmptyStateView
                    emptyStateView.label.text = "Something bad happened"
                    self.tableView.backgroundView = emptyStateView
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    enum Sort : String {
        case Recent = "recent", Top = "top"
    }
}
