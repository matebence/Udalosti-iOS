//
//  OdhlasenieUdaje.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class TokenUdaje : TokenImplementacia, KommunikaciaOdpoved{
   
    private var autentifikaciaUdaje : AutentifikaciaUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    private var udalostiUdaje : UdalostiUdaje!

    init() {
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
    }
    
    func zrusToken() {
        let pouzivatelskeUdaje: NSDictionary = uvodnaObrazovkaUdaje.prihlasPouzivatela()
        self.udalostiUdaje.odhlasenie(email: pouzivatelskeUdaje.value(forKey: "email") as! String)
        
        Nastavenia.TOKEN = true
    }
    
    func novyToken() {
        if Nastavenia.TOKEN {
            let pouzivatelskeUdaje: NSDictionary = uvodnaObrazovkaUdaje.prihlasPouzivatela()
            let miesto: NSDictionary = udalostiUdaje.miestoPrihlasenia()

            autentifikaciaUdaje.prihlasenie(
                email: pouzivatelskeUdaje.value(forKey: "email") as! String,
                heslo: pouzivatelskeUdaje.value(forKey: "heslo") as! String,
                stat: miesto.value(forKey: "stat") as! String,
                okres: miesto.value(forKey: "okres") as! String,
                mesto: miesto.value(forKey: "mesto") as! String)
        }
        Nastavenia.TOKEN = false
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        switch od {
        case Nastavenia.AUTENTIFIKACIA_PRIHLASENIE:
            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                print("Novy token generovany")
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
}