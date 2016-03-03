class Donation {
    let iden: String
    let amount: Int
    let support: Bool
    let event: Event!
    let pac: Pac!
    
    init(data: [String : AnyObject]) throws {
        if let iden = data["iden"] as? String, amount = data["amount"] as? Int, support = data["support"] as? Bool, event = data["event"] as? [String : AnyObject], pac = data["pac"] as? [String : AnyObject] {
            self.iden = iden
            self.amount = amount
            self.support = support
            do {
                self.event = try Event(data: event)
            } catch let e {
                self.event = nil
                self.pac = nil
                throw e
            }
            do {
                self.pac = try Pac(data: pac)
            } catch let e {
                self.pac = nil
                throw e
            }
        } else {
            iden = ""
            amount = 0
            support = false
            event = nil
            pac = nil
            throw Error.QuietError("Invalid donation data")
        }
    }
    
    func setLabel(label: UILabel) {
        if support {
            label.textColor = Colors.support
            label.text = "Support ($\(amount))"
        } else {
            label.textColor = Colors.oppose
            label.text = "Oppose ($\(amount))"
        }
    }
}