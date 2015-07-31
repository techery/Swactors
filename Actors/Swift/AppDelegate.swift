//
//  AppDelegate.swift
//  Actors
//
//  Created by Sergey Zenchenko on 7/22/15.
//  Copyright © 2015 Techery. All rights reserved.
//

import UIKit


class AuthActor {
    func run() {
        print("1")
    }
    
    func test() {
        
    }
}

class Context {
    func get<T:Any>(type:T.Type) -> T {
        return AuthActor() as! T;
    }
    
    func get(type:Any) -> Any {
        return AuthActor();
    }
    
    func inject(target:Any) {
        let targetMirror = reflect(target)
        for i in 0..<targetMirror.count {
            let (_, mirror) = targetMirror[i]
            if let spec = mirror.value as? Injector {
                let type = spec.dependencyType()
                let dependency = get(type)
                spec.setDependency(dependency)
                print(mirror.summary)
            }
        }
    }
}

protocol Injector {
    func dependencyType() -> Any
    func setDependency(value:Any)
}

class InternalInjection<T> : Injection<T>, Injector {
    
    override init(type:T.Type) {
        super.init(type: type)
    }
    
    func dependencyType() -> Any {
        return type
    }
    
    func setDependency(value: Any) {
        self.val = value as? T
    }
}

class Injection<T> {
    private var val:T?
    let type:T.Type
    
    init(type:T.Type) {
        self.type = type
    }
    
    func get() -> T {
        return val!
    }
}


class A {
    func get() -> Int {
        return 0
    }
    
    static func get() -> Int {
        return 0
    }
    
    let call = { () -> Int in
        return 1
    }
}

class B : A {
    let x = get()
}

func Inject<T>(type:T.Type) -> Injection<T> {
    return InternalInjection<T>(type:type) as Injection<T>
}

class Test {
    let actor = Inject(AuthActor)
}

protocol LocatorInitializer {
    init(locator:Context)
}

class Test2 : LocatorInitializer {
    let actor:AuthActor
    
    required init(locator:Context) {
        self.actor = locator.get(AuthActor)
    }
}

func create<T:LocatorInitializer>(type:T.Type) -> Context -> T {
    return { locator in
        return T(locator: locator)
    }
}

protocol Provider {
    func provide(context:Context) -> Any;
}

class ValueProvider : Provider {
    let value:Any
    init(val:Any) {
        self.value = val
    }
    
    func provide(context: Context) -> Any {
        return value
    }
}

class Module {
    
    var providers:[String:Provider] = Dictionary()
    
    private func provide(key:String, value:Provider) {
        providers[key] = value
    }
    
    func provide(key:String, value:(context:Context) -> Any) {
        
    }
    
    func provide(key:String, value:Any) {
        provide(key, value:ValueProvider(val: value))
    }
    
    func setup() {
        
    }
}

class AppModule : Module {

    override func setup() {
        
        provide("demo") { (context) -> Any in
            return "de"
        }
        
        provide("qwd", value: 1)
    }
}

struct User {
    let name:String
    let email:String
}

protocol Mapping {
    func resultType() -> Any
    func map(input:Any) -> Any
}

class GenericMapping<I, O> : Mapping {
    let mapping: (I) -> O
    
    init(map:(I) -> O) {
        self.mapping = map
    }
    
    func resultType() -> Any {
        return O.self
    }
    
    func map(input:Any) -> Any {
        let inp = input as? I
        return mapping(inp!)
    }
}

class Mapper {
    
    var mappers:[Mapping] = []
    
    func addMapping<I, O>(map:(I) -> O) {
        mappers.append(GenericMapping(map: map))
    }
    
    func map<I, O>(input:I) -> O  {
        for mapper in mappers {
            if mapper.resultType() is O.Type {
                return mapper.map(input) as! O
            }
        }
        return NSException() as! O
    }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let playground = Playground()
        playground.main()
        
//        let test = Test()
//        
//
//        let mapper = Mapper()
//        
//        mapper.addMapping { (name:String) -> User in
//            return User(
//                name: name,
//                email: name
//            )
//        }
//        
//        let cls:AnyClass = Test.self
//        
//        print(cls.description())
//        
//        let actorLocator = Context();
//        actorLocator.inject(test)
//
//        let test2 = Test2(locator: actorLocator)
//        let test22 = create(Test2)(actorLocator)
//        
//        test22.actor.run()
//        test2.actor.run()
//
//        test.actor.get().run()
//        test.actor.val = nil
        
        return true
    }
}

