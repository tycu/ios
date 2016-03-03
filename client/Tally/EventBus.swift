import Foundation

class EventBus {
    static var registered: [UInt : [String : (AnyObject?) -> Void]] = [:]
    
    class func register(target: AnyObject, forEvent: String, withHandler: (AnyObject?) -> Void) {
        assert(NSThread.currentThread().isMainThread)
        
        let id = ObjectIdentifier(target).uintValue
        var handlers = registered[id] ?? [:]
        handlers[forEvent] = withHandler
        registered[id] = handlers
    }
    
    class func unregister(target: AnyObject) {
        assert(NSThread.currentThread().isMainThread)
        
        let id = ObjectIdentifier(target).uintValue
        registered.removeValueForKey(id)
    }
    
    class func post(event: String) {
        post(event, withData: nil)
    }
    
    class func post(event: String, withData: [String : AnyObject]?) {
        if (NSThread.currentThread().isMainThread) {
            p("Posting \(event)")
            for (_, handlers) in registered {
                if let handler = handlers[event] {
                    handler(withData)
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                EventBus.post(event)
            })
        }
    }
}
