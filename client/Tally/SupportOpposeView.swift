class SupportOpposeView : UIView {
    private var _supportTotal = 0
    var supportTotal: Int {
        get {
            return _supportTotal
        }
        set {
            _supportTotal = newValue
            setNeedsDisplay()
        }
    }
    private var _opposeTotal = 0
    var opposeTotal: Int {
        get {
            return _opposeTotal
        }
        set {
            _opposeTotal = newValue
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let weight = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let support = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let oppose = 1 - support
        
        let amount = 1000 * weight
        supportTotal = Int(amount * support)
        opposeTotal = Int(amount * oppose)
        
        let halfWidth = bounds.width / 2
        
        let font = UIFont.boldSystemFontOfSize(max(bounds.height - 6, 11))
        let textAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        let textPadding = CGFloat(6)
        
        let opposeText = (opposeTotal == 0 ? "" : "-$\(opposeTotal)") as NSString
        let supportText = (supportTotal == 0 ? "" : "+$\(supportTotal)") as NSString
        
        let opposeTextSize = opposeText.sizeWithAttributes(textAttributes)
        let supportTextSize = supportText.sizeWithAttributes(textAttributes)
        
        let barWidth = bounds.width * 2 / 3 * weight
        
        let opposeWidth = max(max(min(barWidth * oppose, halfWidth), halfWidth * 0.1), opposeTextSize.width + (2 * textPadding))
        let supportWidth = max(max(min(barWidth * support, halfWidth), halfWidth * 0.1), supportTextSize.width + (2 * textPadding))
        
        let opposeBar = CGRect(origin: CGPoint(x: halfWidth - opposeWidth, y: 0), size: CGSize(width: opposeWidth, height: bounds.height))
        let supportBar = CGRect(origin: CGPoint(x: halfWidth, y: 0), size: CGSize(width: supportWidth, height: bounds.height))
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, Colors.oppose.CGColor)
        CGContextFillRect(context, opposeBar)
        
        CGContextSetFillColorWithColor(context, Colors.support.CGColor)
        CGContextFillRect(context, supportBar)
        
        let divider = CGRect(origin: CGPoint(x: halfWidth - 1, y: 0), size: CGSize(width: 2, height: bounds.height))
        CGContextSetFillColorWithColor(context, Colors.primary.CGColor)
        CGContextFillRect(context, divider)
        
        opposeText.drawInRect(CGRect(origin: CGPoint(x: (halfWidth - opposeWidth) + textPadding, y: 0 + ((bounds.height - opposeTextSize.height) / 2)), size: opposeTextSize), withAttributes: textAttributes)
        supportText.drawInRect(CGRect(origin: CGPoint(x: halfWidth + (supportWidth - supportTextSize.width) - textPadding, y: 0 + ((bounds.height - supportTextSize.height) / 2)), size: supportTextSize), withAttributes: textAttributes)
    }
}
