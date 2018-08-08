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
    
    var window: UIWindow?
    var sqliteDatabaza: SQLiteDatabaza!
    
    let udalostiAdresa = "http://localhost:8888/"
    let geoAdresa = "http://ip-api.com/"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.ukazkaAplikacie()
        self.nastavNavigaciu()
        
        return true
    }
    
    func ukazkaAplikacie(){
        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
        let preferencie = UserDefaults.standard
        
        var obsah = udalosti.instantiateViewController(withIdentifier: "RychlaUkazkaAplikacie")
        if preferencie.bool(forKey: "prvyStart") {
            self.sqliteDatabaza = SQLiteDatabaza()
            
            if self.sqliteDatabaza.pouzivatelskeUdaje(){
                obsah = udalosti.instantiateViewController(withIdentifier: "UvodnaObrazovka")
            }else{
                obsah = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
            }
        }
        
        window?.rootViewController = obsah
        window?.makeKeyAndVisible()
    }
    
    func nastavNavigaciu(){
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().isTranslucent = true
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
