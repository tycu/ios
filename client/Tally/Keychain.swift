import SSKeychain
import FBSDKLoginKit

class Keychain {
    private static let service = "Tally"
    private static let account = NSBundle.mainBundle().bundleIdentifier!
    
    class func setAccessToken(token: String) {
        SSKeychain.setPassword(token, forService: service, account: account)
    }
    
    class func getAccessToken() -> String? {
        return SSKeychain.passwordForService(service, account: account)
    }
    
    class func clear() {
        SSKeychain.deletePasswordForService(service, account: account)
        FBSDKLoginManager().logOut()
        FBSDKProfile.setCurrentProfile(nil)
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
}
