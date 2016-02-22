import UIKit

extension UILabel {
    func presentMarkdown(markdown: String) {
        var needsBold = [String]()
        var substring = markdown
        while true {
            guard let startRange = substring.rangeOfString("**") else {
                break
            }
            guard let endRange = substring.substringFromIndex(startRange.endIndex).rangeOfString("**") else {
                break
            }
            
            needsBold.append(substring.substringFromIndex(startRange.endIndex).substringToIndex(endRange.startIndex))
            substring = substring.substringFromIndex(startRange.endIndex).substringFromIndex(endRange.endIndex)
        }
        
        var needsItalic = [String]()
        substring = markdown
        while true {
            guard let startRange = substring.rangeOfString("*") else {
                break
            }
            guard let endRange = substring.substringFromIndex(startRange.endIndex).rangeOfString("*") else {
                break
            }
            
            needsItalic.append(substring.substringFromIndex(startRange.endIndex).substringToIndex(endRange.startIndex))
            substring = substring.substringFromIndex(startRange.endIndex).substringFromIndex(endRange.endIndex)
        }
        
        if (needsBold.count > 0 || needsItalic.count > 0) {
            let cleanSummary = markdown.stringByReplacingOccurrencesOfString("*", withString: "")
            let attributedString = NSMutableAttributedString(string: cleanSummary)
            for string in needsBold {
                attributedString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(font.pointSize), range: (cleanSummary as NSString).rangeOfString(string))
            }
            for string in needsItalic {
                attributedString.addAttribute(NSFontAttributeName, value: UIFont.italicSystemFontOfSize(font.pointSize), range: (cleanSummary as NSString).rangeOfString(string))
            }
            
            attributedText = attributedString
        } else {
            text = markdown
        }
    }
}
