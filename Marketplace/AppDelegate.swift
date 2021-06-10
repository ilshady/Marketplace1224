//
//  AppDelegate.swift
//  Marketplace
//
//  Created by Нуржан Орманали on 24.02.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let viewController = TabBarController()
        window?.rootViewController = viewController
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.5176470588, green: 0.7607843137, blue: 0.08235294118, alpha: 1)
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .portrait
    }


}

