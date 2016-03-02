import UIKit

class Colors {
    static let purple = UIColor(hex: "#663399")
    static let support = UIColor.darkTextColor() // UIColor(hex: "#33AA33")
    static let oppose = UIColor(hex: "#AAAAAA") // UIColor(hex: "#F57200")
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
