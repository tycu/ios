import TTTAttributedLabel

class MarkdownLabel: TTTAttributedLabel, TTTAttributedLabelDelegate {
    
    func presentMarkdown(markdown: String?) {
        presentMarkdown(markdown, paragraphFont: UIFont.systemFontOfSize(font.pointSize), strongFont: UIFont.boldSystemFontOfSize(font.pointSize), emphasisFont: UIFont.italicSystemFontOfSize(font.pointSize))
    }
    
    func presentMarkdown(markdown: String?, paragraphFont: UIFont, strongFont: UIFont, emphasisFont: UIFont) {
        if markdown == nil {
            attributedText = NSMutableAttributedString(string: "")
            return
        }
        
        delegate = self
        linkAttributes = [NSForegroundColorAttributeName: textColor, NSUnderlineStyleAttributeName: NSNumber(bool:true)]
        activeLinkAttributes = [NSForegroundColorAttributeName: textColor, NSUnderlineStyleAttributeName: NSNumber(bool:false)]
        
        let parser = MarkdownParser(paragraphFont: paragraphFont, strongFont: strongFont, emphasisFont: emphasisFont)
        let attributedString = parser.attributedStringFromMarkdown(markdown!)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, attributedString.length))
        
        attributedText = attributedString
        
        attributedText.enumerateAttributesInRange(NSRange(location:0, length: attributedText.length), options: [], usingBlock: { attributes, range, stop in
            if let url = attributes[NSLinkAttributeName] as? NSURL {
                self.addLinkToURL(url, withRange: range)
            }
        })
    }
    
    func attributedLabel(label: TTTAttributedLabel, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    private class MarkdownParser {
        private var parsingPairs = [ExpressionPair]()
        var paragraphFont: UIFont
        var strongFont: UIFont
        var emphasisFont: UIFont
        
        init(paragraphFont: UIFont, strongFont: UIFont, emphasisFont: UIFont) {
            self.paragraphFont = paragraphFont
            self.strongFont = strongFont
            self.emphasisFont = emphasisFont
            
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
            
            // Emphasis
            parsingPairs.append(ExpressionPair(regex: try! NSRegularExpression(pattern: "(\\*|_)(.+?)(\\1)", options: []), mutator: { match, attributedString in
                attributedString.deleteCharactersInRange(match.rangeAtIndex(3))
                attributedString.addAttributes([NSFontAttributeName: self.emphasisFont], range: match.rangeAtIndex(2))
                attributedString.deleteCharactersInRange(match.rangeAtIndex(1))
            }))
        }
        
        func attributedStringFromMarkdown(markdown: String) -> NSMutableAttributedString {
            let attributedString = NSMutableAttributedString(string: markdown)
            
            attributedString.addAttribute(NSFontAttributeName, value: paragraphFont, range: NSRange(location: 0, length: attributedString.length))
            
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
}