import Foundation
import UIKit

class MarkdownParser {
    private var parsingPairs = [ExpressionPair]()
    var strongFont = UIFont.boldSystemFontOfSize(12)
    var emphasisFont = UIFont.italicSystemFontOfSize(12)
    
    init() {
        // Links
        parsingPairs.append(ExpressionPair(regex: try! NSRegularExpression(pattern: "\\[.*?\\]\\([^\\)]*\\)", options: [.DotMatchesLineSeparators]), mutator: { match, attributedString in
            let nsString = attributedString.string as NSString
            let linkStartInResult = nsString.rangeOfString("(", options: .BackwardsSearch, range: match.range).location
            let linkRange = NSRange(location: linkStartInResult, length: match.range.length + match.range.location - linkStartInResult - 1)
            let linkUrl = nsString.substringWithRange(NSRange(location: linkRange.location + 1, length: linkRange.length - 1))
            if let url = NSURL(string: linkUrl) ?? NSURL(string: linkUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!) {
                let linkTextEndLocation = nsString.rangeOfString("]", options: [], range: match.range).location
                let linkTextRange = NSRange(location: match.range.location + 1, length: linkTextEndLocation - match.range.location - 1)
                attributedString.deleteCharactersInRange(NSRange(location: linkRange.location - 1, length: linkRange.length + 2))
                attributedString.addAttribute(NSLinkAttributeName, value: url, range: linkTextRange)
                attributedString.deleteCharactersInRange(NSRange(location: match.range.location, length: 1))
            }
        }))
        
        // Strong
        parsingPairs.append(ExpressionPair(regex: try! NSRegularExpression(pattern: "(\\*\\*|__)(.+?)(\\1)", options: []), mutator: { match, attributedString in
            attributedString.deleteCharactersInRange(match.rangeAtIndex(3))
            attributedString.addAttributes([NSFontAttributeName: self.strongFont], range: match.rangeAtIndex(2))
            attributedString.deleteCharactersInRange(match.rangeAtIndex(1))
        }))
        
//        // Emphasis
        parsingPairs.append(ExpressionPair(regex: try! NSRegularExpression(pattern: "(\\*|_)(.+?)(\\1)", options: []), mutator: { match, attributedString in
            attributedString.deleteCharactersInRange(match.rangeAtIndex(3))
            attributedString.addAttributes([NSFontAttributeName: self.emphasisFont], range: match.rangeAtIndex(2))
            attributedString.deleteCharactersInRange(match.rangeAtIndex(1))
        }))
    }
    
    func attributedStringFromMarkdown(markdown: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: markdown)
        
        for pair in parsingPairs {
            var done = false
            var location = 0
            while !done {
                if let match = pair.regex.firstMatchInString(attributedString.string, options: [.WithoutAnchoringBounds], range: NSRange(location: location, length: attributedString.length - location)) {
                    let oldLength = attributedString.length;
                    pair.mutator(match, attributedString);
                    let newLength = attributedString.length;
                    location = match.range.location + match.range.length + newLength - oldLength;
                } else {
                    done = true
                }
            }
        }
        
        return attributedString
    }
}

private struct ExpressionPair {
    let regex: NSRegularExpression
    let mutator: (NSTextCheckingResult, NSMutableAttributedString) -> Void
}
