import UIKit

class Colors {
    static let purple = UIColor(hex: "#663399")
    
    static let lightPurple = UIColor(hex: "#AA77CC")
    
    static let red = UIColor(hex: "#CC3333")
    static let blue = UIColor(hex: "#3333CC")
    static let green = UIColor(hex: "#33AA33")
    static let orange = UIColor(hex: "#F57200")
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
