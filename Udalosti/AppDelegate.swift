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
    
    let ipAdresa = "http://ip-api.com/";
    let udalostiAdresa = "http://app-udalosti.8u.cz/";
    let geoAdresa = "https://eu1.locationiq.com/v1/reverse.php?key=" + Nastavenia.POZICIA_TOKEN;

    var window: UIWindow?
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    
    func ukazkaAplikacie(){
        print("Metoda ukazkaAplikacie bola vykonana")
        
        let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
        let preferencie = UserDefaults.standard
        
        var obsah = udalosti.instantiateViewController(withIdentifier: "RychlaUkazkaAplikacie")
        if preferencie.bool(forKey: "prvyStart") {
            self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()

            if self.uvodnaObrazovkaUdaje.zistiCiPouzivatelExistuje(){
                obsah = udalosti.instantiateViewController(withIdentifier: "UvodnaObrazovka")
            }else{
                obsah = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
            }
        }
        
        self.window?.rootViewController = obsah
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("Metoda application bola vykonana")

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.ukazkaAplikacie()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Metoda applicationDidEnterBackground bola vykonana")

        let tokenUdaje: TokenUdaje = TokenUdaje()
        tokenUdaje.zrusToken()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Metoda applicationWillEnterForeground bola vykonana")

        let tokenUdaje: TokenUdaje = TokenUdaje()
        tokenUdaje.novyToken()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Metoda applicationWillResignActive bola vykonana")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("Metoda applicationDidBecomeActive bola vykonana")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Metoda applicationWillTerminate bola vykonana")
    }
}
