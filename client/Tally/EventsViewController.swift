import UIKit
import SDWebImage

class EventsViewController : UITableViewController {
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator.center = tableView.center
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        refresh()
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
        
        cell.summary.text = event.summary
        
        if let thumbnailUrl = event.thumbnailUrl {
            cell.thumbnail.layer.cornerRadius = 2
            cell.thumbnail.layer.masksToBounds = true
            cell.thumbnail.sd_setImageWithURL(NSURL(string: thumbnailUrl))
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let eventViewController = storyboard!.instantiateViewControllerWithIdentifier("StoryViewController") as! EventViewController
        eventViewController.event = events[indexPath.row]
        navigationController!.pushViewController(eventViewController, animated: true)
    }
    
    func refresh() {
        Requests.get(Endpoints.events, completionHandler: { response, error in
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
            }
            
            self.refreshControl!.endRefreshing()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.tableView.reloadData()
                
                if (self.events.count == 0) {
                    if response?.statusCode == 200 {
                        // There are no events right now
                    } else {
                        // Something bad happened
                    }
                } else {
                    self.tableView.backgroundView = nil
                }
            }
        })
    }
}
