import UIKit

class ScoreboardViewController : UIViewController {
    private let segmentedControl = UISegmentedControl(items: ["Weekly", "Monthly", "All Time"])
    private let scoreboards: [Scoreboard] = [.Weekly, .Monthly, .AllTime]
    private var activeScoreboard: Scoreboard {
        return scoreboards[segmentedControl.selectedSegmentIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 270, height: segmentedControl.frame.height)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: "segmentIndexSelected:", forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.titleView = segmentedControl
        
        refresh(self)
    }
    
    func segmentIndexSelected(sender: UISegmentedControl) {
        refresh(self)
    }
    
    func refresh(sender: AnyObject) {
        let scoreboard = activeScoreboard
        let url = Endpoints.scoreboards + "/" + scoreboard.rawValue
        Requests.get(url, completionHandler: { response, error in
            print(response?.body, error)
        })
    }
    
    enum Scoreboard : String {
        case Weekly = "weekly", Monthly = "monthly", AllTime = "all-time"
    }
}
