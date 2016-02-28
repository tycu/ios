class SupportOpposeView : UIView {
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let weight = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let support = CGFloat(Float(arc4random()) /  Float(UInt32.max))
        let oppose = 1 - support
        
        let halfWidth = bounds.width / 2
        let thirdHeight = bounds.height / 3
        let winningExtraHeight = bounds.height / 6
        
        let barWidth = halfWidth * weight
        
        let supportWidth = barWidth * support
        let supportHeight = thirdHeight + (support > oppose ? winningExtraHeight : 0)
        let opposeWidth = barWidth * oppose
        let opposeHeight = thirdHeight + (oppose > support ? winningExtraHeight : 0)
        
        
        let opposeBar = CGRect(origin: CGPoint(x: halfWidth - supportWidth, y: (bounds.height - supportHeight) / 2), size: CGSize(width: supportWidth, height: supportHeight))
        let supportBar = CGRect(origin: CGPoint(x: halfWidth, y: (bounds.height - opposeHeight) / 2), size: CGSize(width: opposeWidth, height: opposeHeight))
        
        
        
        
        
//        let supportHeight = CGFloat(quarterHeight + (supportWinning ? 2 : 0))
//        let opposeHeight = CGFloat(quarterHeight + (supportWinning ? 0 : 2))
//        
//        let opposeBar = CGRect(origin: CGPoint(x: halfWidth - ((1 - supportFloat) * rectWidth), y: bounds.height - (2 * quarterHeight) - (supportWinning ? 0 : 1)), size: CGSize(width: ((1 - supportFloat) * rectWidth), height: opposeHeight))
//        
//        let supportBar = CGRect(origin: CGPoint(x: halfWidth, y: bounds.height - (2 * quarterHeight) - (supportWinning ? 1 : 0)), size: CGSize(width: supportFloat * rectWidth, height: supportHeight))
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, Colors.orange.CGColor)
        CGContextFillRect(context, opposeBar)
        
        CGContextSetFillColorWithColor(context, Colors.green.CGColor)
        CGContextFillRect(context, supportBar)
        
        let divider = CGRect(origin: CGPoint(x: halfWidth - 1, y: 0), size: CGSize(width: 2, height: bounds.height))
        CGContextSetFillColorWithColor(context, UIColor.darkTextColor().CGColor)
        CGContextFillRect(context, divider)
    }
}
