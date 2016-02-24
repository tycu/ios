import UIKit
import SDWebImage

class EventsViewController : UITableViewController {
    private let segmentedControl = UISegmentedControl(items: ["Recent", "Top"])
    private let  activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    private var events = [Sort : [Event]]()
    private var activeSort: Sort {
        return segmentedControl.selectedSegmentIndex == 0 ? .Recent : .Top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 180, height: segmentedControl.frame.height)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentIndexSelected:", forControlEvents: .ValueChanged)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
        
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = Colors.purple
        refreshControl!.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = segmentedControl
        
        refresh(self)
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
        
        cell.headline.presentMarkdown(event.headline)
        
        cell.time.text = event.created.humanReadableTimeSinceNow
        
        if let thumbnailUrl = event.politician?.thumbnailUrl {
            cell.thumbnail.layer.cornerRadius = cell.thumbnail.frame.width / 2.0
            cell.thumbnail.layer.masksToBounds = true
            cell.thumbnail.sd_setImageWithURL(NSURL(string: thumbnailUrl))
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let eventViewController = storyboard!.instantiateViewControllerWithIdentifier("StoryViewController") as! EventViewController
        eventViewController.event = events[activeSort]![indexPath.row]
        navigationController!.pushViewController(eventViewController, animated: true)
    }
    
    func segmentIndexSelected(sender: UISegmentedControl) {
        tableView.reloadData()
        tableView.backgroundView = activityIndicator
        
        refresh(self)
    }
    
    func refresh(sender: AnyObject) {
        if sender is EventsViewController && events[activeSort] != nil {
            return
        }
        
        let sort = activeSort
        let url = Endpoints.events + "?sort=" + sort.rawValue
        Requests.get(url, completionHandler: { response, error in
            self.refreshControl!.endRefreshing()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.events[sort]?.removeAll()
                
                if response?.statusCode == 200 {
                    self.events[sort] = [Event]()
                    if let stories = response!.body!["events"] as? [[String : AnyObject]] {
                        for story in stories {
                            do {
                                self.events[sort]!.append(try Event(data: story))
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
            }
        })
    }
    
    enum Sort : String {
        case Recent = "recent", Top = "top"
    }
}
