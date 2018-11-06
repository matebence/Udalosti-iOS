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
    
    let udalostiAdresa = "http://app-udalosti.8u.cz/"
    let geoAdresa = "http://ip-api.com/"
    
    func ukazkaAplikacie(){
        print("Metoda ukazkaAplikacie bola vykonana")
        
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.ukazkaAplikacie()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let tokenUdaje: TokenUdaje = TokenUdaje()
        tokenUdaje.zrusToken()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        let tokenUdaje: TokenUdaje = TokenUdaje()
        tokenUdaje.novyToken()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
