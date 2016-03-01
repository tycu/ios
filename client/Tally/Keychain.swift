import SSKeychain
import FBSDKLoginKit

class Keychain {
    private static let service = "Tally"
    private static let account = NSBundle.mainBundle().bundleIdentifier!
    
    class func setToken(token: String) {
        SSKeychain.setAccessibilityType(kSecAttrAccessibleAfterFirstUnlock)
        SSKeychain.setPassword(token, forService: service, account: account)
    }
    
    class func getToken() -> String? {
        return SSKeychain.passwordForService(service, account: account)
    }
    
    class func clear() {
        SSKeychain.deletePasswordForService(service, account: account)
        FBSDKLoginManager().logOut()
    }
}
