import Foundation

protocol MessageHandler {
    func handle(message:Any) -> Future<Any>
}

class VoidMessageHandler<T> : MessageHandler {
    let handler:(msg:T) -> Void
    
    init(_ h:(msg:T) -> Void) {
        handler = h
    }
    
    func handle(message:Any) -> Future<Any> {
        if let convertedMessage = message as? T {
            handler(msg:convertedMessage)
            return Future(success: true);
        } else {
            return Future(failWithErrorMessage: "Can't conver incumming message");
        }
    }
}

class FutureMessageHandler<I, O> : MessageHandler {
    let handler:(msg:I) -> Future<O>
    
    init(_ h:(msg:I) -> Future<O>) {
        handler = h
    }
    
    func handle(message:Any) -> Future<Any> {
        if let convertedMessage = message as? I {
            return handler(msg: convertedMessage).As()
        } else {
            return Future(failWithErrorMessage: "Can't conver incumming message");
        }
    }
}

class ResultMessageHandler<I, O> : MessageHandler {
    let handler:(msg:I) -> O
    
    init(_ h:(msg:I) -> O) {
        handler = h
    }
    
    func handle(message:Any) -> Future<Any> {
        if let convertedMessage = message as? I {
            let result = handler(msg:convertedMessage)
            return Future(success: result);
        } else {
            return Future(failWithErrorMessage: "Can't conver incumming message");
        }
    }
}

