import TTTAttributedLabel

class MarkdownLabel: TTTAttributedLabel, TTTAttributedLabelDelegate {
    private lazy var markdownParser: MarkdownParser = {
        return MarkdownParser(label: self)
    }()
    
    func presentMarkdown(markdown: String) {
        delegate = self
        linkAttributes = [NSForegroundColorAttributeName: textColor, NSUnderlineStyleAttributeName: NSNumber(bool:true)]
        activeLinkAttributes = [NSForegroundColorAttributeName: textColor, NSUnderlineStyleAttributeName: NSNumber(bool:false)]
        
        attributedText = markdownParser.attributedStringFromMarkdown(markdown)
        attributedText.enumerateAttributesInRange(NSRange(location:0, length: attributedText.length), options: [], usingBlock: { attributes, range, stop in
            if let url = attributes[NSLinkAttributeName] as? NSURL {
                self.addLinkToURL(url, withRange: range)
            }
        })
    }
    
    func attributedLabel(label: TTTAttributedLabel, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
}
