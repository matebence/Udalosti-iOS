//
//  OdhlasenieUdaje.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class TokenUdaje : TokenImplementacia, KommunikaciaOdpoved, KommunikaciaData{
    
    private var autentifikaciaUdaje : AutentifikaciaUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    private var udalostiUdaje : UdalostiUdaje!
    
    init() {
        print("Metoda init - TokenUdaje bola vykonana")

        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
    }
    
    func zrusToken() {
        print("Metoda zrusToken bola vykonana")

        if self.uvodnaObrazovkaUdaje.zistiCiPouzivatelExistuje() {
            let pouzivatelskeUdaje: NSDictionary = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()
            self.udalostiUdaje.odhlasenie(email: pouzivatelskeUdaje.value(forKey: "email") as! String)
            
            Nastavenia.TOKEN = true
        }
    }
    
    func novyToken() {
        print("Metoda novyToken bola vykonana")

        if Nastavenia.TOKEN && self.uvodnaObrazovkaUdaje.zistiCiPouzivatelExistuje(){
            let pouzivatelskeUdaje: NSDictionary = self.uvodnaObrazovkaUdaje.prihlasPouzivatela()

            self.autentifikaciaUdaje.prihlasenie(
                email: pouzivatelskeUdaje.value(forKey: "email") as! String,
                heslo: pouzivatelskeUdaje.value(forKey: "heslo") as! String)
        }
        Nastavenia.TOKEN = false
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedeServera - TokenUdaje bola vykonana")

        switch od {
            case Nastavenia.AUTENTIFIKACIA_PRIHLASENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    print("Novy token generovany")
                    
                    let email =  udaje!.value(forKey: "email") as! String
                    let heslo = udaje!.value(forKey: "heslo") as! String
                    let token =  udaje!.value(forKey: "token") as! String
                    
                    self.autentifikaciaUdaje.ulozPrihlasovacieUdajeDoDatabazy(
                        email: email,
                        heslo: heslo,
                        token: token)                
                }
                break;
            case Nastavenia.AUTENTIFIKACIA_ODHLASENIE:
                if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                    print("Token odstranene")
                }
                break;
            
        default: break
        }
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - TokenUdaje bola vykonana")

    }
}
