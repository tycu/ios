extension Int {
    private static let numberFormatter: NSNumberFormatter = {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return numberFormatter
    }()

    var localizedString: String {
        return Int.numberFormatter.stringFromNumber(self)!
    }
}
