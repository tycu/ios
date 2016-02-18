import UIKit
import SDWebImage

class NewsViewController : UITableViewController {
    var stories = [Story]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        refresh()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let story = stories[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        
        cell.blurb.text = story.blurb
        
        if let thumbnailUrl = story.thumbnailUrl {
            cell.thumbnail.layer.cornerRadius = 20
            cell.thumbnail.layer.masksToBounds = true
            cell.thumbnail.sd_setImageWithURL(NSURL(string: thumbnailUrl))
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let storyViewController = storyboard!.instantiateViewControllerWithIdentifier("StoryViewController") as! StoryViewController
        navigationController!.pushViewController(storyViewController, animated: true)
    }
    
    func refresh() {
        Requests.get(Endpoints.stories, completionHandler: { response, error in
            self.stories.removeAll()
            
            if response?.statusCode == 200 {
                if let stories = response!.body["stories"] as? [[String : AnyObject]] {
                    for story in stories {
                        self.stories.append(Story(data: story))
                    }
                }
                return
            }
            
            // Else
        })
    }
}
