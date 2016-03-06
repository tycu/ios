import UIKit

class Colors {
    static let primary = UIColor(hex: "#008AB8")
    
    static let support: UIColor = {
        let rawComponents = CGColorGetComponents(primary.CGColor)
        let components = [Float(rawComponents[0]), Float(rawComponents[1]), Float(rawComponents[2])]
        return UIColor(colorLiteralRed: components[0], green: components[1], blue: components[2], alpha: 0.85)
    }()
    
    static let oppose: UIColor = {
        let rawComponents = CGColorGetComponents(primary.CGColor)
        let components = [Float(rawComponents[0]), Float(rawComponents[1]), Float(rawComponents[2])]
        return UIColor(colorLiteralRed: components[0], green: components[1], blue: components[2], alpha: 0.5)
    }()
    
    static let democrat = UIColor(hex: "#0049A3")
    static let republican = UIColor(hex: "#BE2600")
}

extension UIColor {
    
    convenience init(hex: String) {
        let hexString = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner = NSScanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
