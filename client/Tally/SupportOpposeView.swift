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
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard _event != nil else {
            return
        }
        
        let weight = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let support = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let oppose = 1 - support
        
        let halfWidth = bounds.width / 2
        let halfHeight = bounds.height / 2
        
        let barWidth = halfWidth * weight
        
        let supportWidth = max(barWidth * support, halfWidth * 0.1)
        let opposeWidth = max(barWidth * oppose, halfWidth * 0.1)
        
        let opposeBar = CGRect(origin: CGPoint(x: halfWidth - supportWidth, y: (bounds.height - halfHeight) / 2), size: CGSize(width: supportWidth, height: halfHeight))
        let supportBar = CGRect(origin: CGPoint(x: halfWidth, y: (bounds.height - halfHeight) / 2), size: CGSize(width: opposeWidth, height: halfHeight))
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, Colors.oppose.CGColor)
        CGContextFillRect(context, opposeBar)
        
        CGContextSetFillColorWithColor(context, Colors.support.CGColor)
        CGContextFillRect(context, supportBar)
        
        let divider = CGRect(origin: CGPoint(x: halfWidth - 1, y: 0), size: CGSize(width: 2, height: bounds.height))
        CGContextSetFillColorWithColor(context, UIColor(colorLiteralRed: 0.35, green: 0.35, blue: 0.35, alpha: 1).CGColor)
        CGContextFillRect(context, divider)
    }
}
