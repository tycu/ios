import SSKeychain

class Keychain {
    private static let service = "Tally"
    private static let account = NSBundle.mainBundle().bundleIdentifier!
    
    class func setPassword(password: String) {
        SSKeychain.setAccessibilityType(kSecAttrAccessibleAfterFirstUnlock)
        SSKeychain.setPassword(password, forService: service, account: account)
    }
    
    class func getPassword() -> String? {
        return SSKeychain.passwordForService(service, account: account)
    }
    
    class func clear() {
        SSKeychain.deletePasswordForService(service, account: account)
    }
}
