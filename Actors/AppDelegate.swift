//
//  AppDelegate.swift
//  Actors
//
//  Created by Sergey Zenchenko on 7/22/15.
//  Copyright © 2015 Techery. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        let locator:ServiceLocator = ServiceLocator { locator in
            locator.register(DTSessionStorage())
            locator.register(SettingsStorage())
        }

        let system = DTMainActorSystem(configs: TripsConfigs(), serviceLocator: locator) { builder in
            builder.addSingleton(AuthActor)
            builder.addSingleton(DTSessionActor)
            builder.addSingleton(SessionAPIActor)
            builder.addSingleton(APIActor)
            builder.addSingleton(MappingActor)
            builder.addSingleton(SettingsActor)
        }

        let loginViewModel = LoginViewModel(actorSystem: system)
        window?.rootViewController = LoginViewController(viewModel: loginViewModel)
        window?.makeKeyAndVisible()

        
        return true
    }
}

