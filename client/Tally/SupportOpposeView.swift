class SupportOpposeView : UIView {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext();
        let halfWidth = bounds.width / 2
        
//        let font = UIFont.systemFontOfSize(11)
//        
//        let oppose = "Oppose" as NSString
//        let opposeRect = oppose.sizeWithAttributes([NSFontAttributeName: font])
//        let opposeDrawRect = CGRect(origin: CGPoint(x: halfWidth - opposeRect.width - 8, y: 0), size: CGSize(width: opposeRect.width, height: opposeRect.height))
//        oppose.drawInRect(opposeDrawRect, withAttributes: [NSFontAttributeName: font])
//        
//        let support = "Support" as NSString
//        let supportRect = support.sizeWithAttributes([NSFontAttributeName: font])
//        let supportDrawRect = CGRect(origin: CGPoint(x: halfWidth + 8, y: 0), size: CGSize(width: supportRect.width, height: supportRect.height))
//        support.drawInRect(supportDrawRect, withAttributes: [NSFontAttributeName: font])
        
        let rectWidth = halfWidth * CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let flexSpace = halfWidth - rectWidth
        
        let supportFloat = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let supportWinning = supportFloat >= 0.5
        
        let supportHeight = CGFloat(4 + (supportWinning ? 2 : 0))
        let opposeHeight = CGFloat(4 + (supportWinning ? 0 : 2))
        
        let opposeBar = CGRect(origin: CGPoint(x: halfWidth - ((1 - supportFloat) * rectWidth), y: bounds.height - 8 - (supportWinning ? 0 : 1)), size: CGSize(width: ((1 - supportFloat) * rectWidth), height: opposeHeight))
        
        let supportBar = CGRect(origin: CGPoint(x: halfWidth, y: bounds.height - 8 - (supportWinning ? 1 : 0)), size: CGSize(width: supportFloat * rectWidth, height: supportHeight))
        
        
        CGContextSetFillColorWithColor(context, Colors.orange.CGColor)
        CGContextFillRect(context, opposeBar)
        
        CGContextSetFillColorWithColor(context, Colors.green.CGColor)
        CGContextFillRect(context, supportBar)
        
//        let rect = CGRect(origin: CGPoint(x: flexSpace + (supportFloat * rectWidth), y: bounds.height - 8), size: CGSize(width: rectWidth, height: 4))
//        CGContextSetFillColorWithColor(context, Colors.lightPurple.CGColor)
//        CGContextFillRect(context, rect)
        
        let divider = CGRect(origin: CGPoint(x: halfWidth - 1, y: bounds.height - 12), size: CGSize(width: 2, height: 12))
        CGContextSetFillColorWithColor(context, UIColor.darkTextColor().CGColor)
        CGContextFillRect(context, divider)
        
//        let lightColor = UIColor(hex: "#dddddd")
//        
//        let left = CGRect(origin: CGPoint(x: 0, y: bounds.height - 12), size: CGSize(width: 1, height: 12))
//        CGContextSetFillColorWithColor(context, lightColor.CGColor)
//        CGContextFillRect(context, left)
//        
//        let right = CGRect(origin: CGPoint(x: bounds.width - 1, y: bounds.height - 12), size: CGSize(width: 1, height: 12))
//        CGContextSetFillColorWithColor(context, lightColor.CGColor)
//        CGContextFillRect(context, right)
        
        
//        let support = CGFloat(Float(arc4random()) /  Float(UInt32.max))
//        let oppose = 1 - support
        
        
      // Orange and green with border
//        let opposeRect = CGRect(origin: CGPoint(x: halfWidth - (halfWidth * oppose * 0.66), y: 0), size: CGSize(width: halfWidth * oppose * 0.66, height: bounds.height))
//        CGContextSetFillColorWithColor(context, Colors.orange.CGColor)
//        CGContextFillRect(context, opposeRect)
//        
//        let supportRect = CGRect(origin: CGPoint(x: halfWidth, y: 0), size: CGSize(width: halfWidth * support * 0.66, height: bounds.height))
//        CGContextSetFillColorWithColor(context, Colors.green.CGColor)
//        CGContextFillRect(context, supportRect)
//        
//        let pt = 1 * UIScreen.mainScreen().scale
//        
//        CGContextSetStrokeColorWithColor(context, UIColor(hex: "#dddddd").CGColor)
//        CGContextSetLineWidth(context, 1 * pt)
//        CGContextStrokeRect(context, rect)
        

        
        // Purple with divider
//        let rectWidth = halfWidth * CGFloat(Float(arc4random()) /  Float(UInt32.max))
//        let flexSpace = halfWidth - rectWidth
//        
//        let rect = CGRect(origin: CGPoint(x: flexSpace + (support * rectWidth), y: 4), size: CGSize(width: rectWidth, height: bounds.height - 8))
//        CGContextSetFillColorWithColor(context, Colors.lightPurple.CGColor)
//        CGContextFillRect(context, rect)
//        
//        let divider = CGRect(origin: CGPoint(x: halfWidth - 1, y: 0), size: CGSize(width: 2, height: bounds.height))
//        CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
//        CGContextFillRect(context, divider)
        
        // Orange + green, no divider
//        let opposeRect = CGRect(origin: CGPoint(x: halfWidth - (halfWidth * oppose * 0.66), y: 0), size: CGSize(width: halfWidth * oppose * 0.66, height: bounds.height))
//        CGContextSetFillColorWithColor(context, Colors.orange.CGColor)
//        CGContextFillRect(context, opposeRect)
//        
//        let supportRect = CGRect(origin: CGPoint(x: halfWidth, y: 0), size: CGSize(width: halfWidth * support * 0.66, height: bounds.height))
//        CGContextSetFillColorWithColor(context, Colors.green.CGColor)
//        CGContextFillRect(context, supportRect)
    }
}
