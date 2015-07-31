import Foundation

public protocol Request {
    typealias Result
}

class MessageDispatcher {
    var messageHandlers:[String:DTMessageHandler] = [String: DTMessageHandler]()
    
    func classNameFromType<T>(type:T.Type) -> String {
        let className: String = reflect(T.self).summary
        
//        let genericPartStart = className.rangeOfString("<", options: NSStringCompareOptions., range: <#Range<String.Index>?#>, locale: <#NSLocale?#>)
        
        return className
    }
    
    func on<T>(handler:(msg:T) -> Void) {
        let className: String = classNameFromType(T.self)
        messageHandlers[className] = VoidMessageHandler(handler)
    }
    
    func on<T:Request>(handler:(msg:T) -> Future<T.Result>) {
        let className: String = classNameFromType(T.self)
        messageHandlers[className] = FutureMessageHandler(handler)
    }
    
    func on<T:Request>(handler:(msg:T) -> T.Result) {
        let className: String = classNameFromType(T.self)
        messageHandlers[className] = ResultMessageHandler(handler)
    }
    
    func handle(message:Any) -> Future<Any> {
        let className: String = reflect(message).summary
        if let messageHandler = messageHandlers[className] {
            return messageHandler.handle(message)
        }
        return Future(failWithErrorMessage: "Unknown message:#\(className)")
    }
}