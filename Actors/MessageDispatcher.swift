import Foundation

public protocol Request {
    typealias Result
}

class MessageDispatcher {
    var messageHandlers:[String:MessageHandler] = [String:MessageHandler]()
    
    func on<T>(handler:(msg:T) -> Void) {
        let className: String = reflect(T.self).summary
        messageHandlers[className] = VoidMessageHandler(handler)
    }
    
    func on<T:Request>(handler:(msg:T) -> Future<T.Result>) {
        let className: String = reflect(T.self).summary
        messageHandlers[className] = FutureMessageHandler(handler)
    }
    
    func on<T:Request>(handler:(msg:T) -> T.Result) {
        let className: String = reflect(T.self).summary
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