//
//  AppDelegate.swift
//  Udalosti
//
//  Created by Bence Mate on 8/4/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let udalostiAdresa = "http://localhost:8888/"
    let geoAdresa = "http://ip-api.com/"

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
        var rychlaUkazkaAplikacie = udalosti.instantiateViewController(withIdentifier: "RychlaUkazkaAplikacie")
        let preferencie = UserDefaults.standard
        
        if preferencie.bool(forKey: "ukazkaAplikacie") {
            rychlaUkazkaAplikacie = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
        }
    
        window?.rootViewController = rychlaUkazkaAplikacie
        window?.makeKeyAndVisible()
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
