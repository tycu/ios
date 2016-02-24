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
        refreshControl!.tintColor = Colors.purple
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, tabBarController!.tabBar.frame.size.height, 0)
        
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
        
        let markdownParser = MarkdownParser()
        markdownParser.strongFont = UIFont.boldSystemFontOfSize(cell.headline.font.pointSize)
        markdownParser.emphasisFont = UIFont.italicSystemFontOfSize(cell.headline.font.pointSize)
        cell.headline.attributedText = markdownParser.attributedStringFromMarkdown(event.headline)
        
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
        eventViewController.event = events[indexPath.row]
        navigationController!.pushViewController(eventViewController, animated: true)
    }
    
    func refresh() {
        Requests.get(Endpoints.events, completionHandler: { response, error in
            self.refreshControl!.endRefreshing()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
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
