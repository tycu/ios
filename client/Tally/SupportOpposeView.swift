class SupportOpposeView : UIView {
    private var _event: Event?
    var event: Event? {
        get {
            return _event
        }
        set {
            _event = newValue
            setNeedsDisplay()
        }
    }
    private var _politician: Politician?
    var politician: Politician? {
        get {
            return _politician
        }
        set {
            _politician = newValue
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let supportTotal: Int, opposeTotal: Int, barWeight: Double
        if let event = event {
            if let donation = UserData.instance?.eventIdenToDonation[event.iden] {
                supportTotal = donation.event.supportTotal
                opposeTotal = donation.event.opposeTotal
            } else {
                supportTotal = event.supportTotal
                opposeTotal = event.opposeTotal
            }
            barWeight = event.barWeight
        } else if let politician = politician {
            supportTotal = politician.supportTotal
            opposeTotal = politician.opposeTotal
            barWeight = politician.barWeight
        } else {
            return
        }
        
        let halfWidth = bounds.width / 2
        
        let font = UIFont.boldSystemFontOfSize(max(bounds.height - 6, 11))
        let textAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let textPadding = CGFloat(4)
        
        let opposeText = (opposeTotal == 0 ? "" : "▼$\(opposeTotal.localizedString)") as NSString
        let supportText = (supportTotal == 0 ? "" : "▲$\(supportTotal.localizedString)") as NSString
        
        let opposeTextSize = opposeText.sizeWithAttributes(textAttributes)
        let supportTextSize = supportText.sizeWithAttributes(textAttributes)
        
        let barWidth = bounds.width * CGFloat(barWeight)
        
        let total = CGFloat(supportTotal + opposeTotal)
        let oppose = total > 0 ? CGFloat(opposeTotal) / total : 0
        let support = total > 0 ? CGFloat(supportTotal) / total : 0
        
        let opposeWidth = max(max(min(barWidth * oppose, halfWidth), halfWidth * 0.1), opposeTextSize.width + (2 * textPadding))
        let supportWidth = max(max(min(barWidth * support, halfWidth), halfWidth * 0.1), supportTextSize.width + (2 * textPadding))
        
        let opposeBar = CGRect(origin: CGPoint(x: halfWidth - opposeWidth, y: 0), size: CGSize(width: opposeWidth, height: bounds.height))
        let supportBar = CGRect(origin: CGPoint(x: halfWidth, y: 0), size: CGSize(width: supportWidth, height: bounds.height))
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, Colors.oppose.CGColor)
        CGContextFillRect(context, opposeBar)
        
        CGContextSetFillColorWithColor(context, Colors.support.CGColor)
        CGContextFillRect(context, supportBar)
                
        opposeText.drawInRect(CGRect(origin: CGPoint(x: (halfWidth - opposeWidth) + textPadding, y: 0 + ((bounds.height - opposeTextSize.height) / 2)), size: opposeTextSize), withAttributes: textAttributes)
        supportText.drawInRect(CGRect(origin: CGPoint(x: halfWidth + (supportWidth - supportTextSize.width) - textPadding, y: 0 + ((bounds.height - supportTextSize.height) / 2)), size: supportTextSize), withAttributes: textAttributes)
    }
}
