//
//  AutentifikaciaUdaje.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import Alamofire

class AutentifikaciaUdaje : AutentifikaciaImplementacia{

    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private var kommunikaciaOdpoved: KommunikaciaOdpoved
    private var sqliteDatabaza: SQLiteDatabaza
    
    init(kommunikaciaOdpoved: KommunikaciaOdpoved){
        self.kommunikaciaOdpoved=kommunikaciaOdpoved
        self.sqliteDatabaza = SQLiteDatabaza()
    }
    
    func prihlasenie(email: String, heslo: String, stat: String, okres: String, mesto: String) {
        print("Metoda prihlasenie bola vykonana")
        
        let adresa = delegate.udalostiAdresa+"udalosti/index.php/prihlasenie"
        let vstup: Parameters=[
            "email":email,
            "heslo":heslo,
            "pokus_o_prihlasenie":NSUUID().uuidString
        ]
        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value {
                    let udaje = odpoved as! NSDictionary
                    let chyba =  udaje.value(forKey: "chyba") as! Bool?
                    let data : NSMutableDictionary  = [
                        "email": email
                    ]
                    
                    if(chyba)!{
                        let validacia = udaje.value(forKey: "validacia") as! NSDictionary
                        if (validacia.value(forKey: "oznam") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "oznam") as! String, od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:data)
                        } else if (validacia.value(forKey: "email") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "email") as! String, od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:data)
                        } else if (validacia.value(forKey: "heslo") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "heslo") as! String, od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:data)
                        }
                    }else{
                        let pouzivatel = udaje.value(forKey: "pouzivatel") as! NSDictionary
                        
                        data["heslo"] = heslo
                        data["token"] = pouzivatel.value(forKey: "token") as! String
                        
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:data)
                    }
                }
        }
    }
    
    func miestoPrihlasenia(email: String, heslo: String) {
        print("Metoda miestoPrihlasenia bola vykonana")

        let adresa = delegate.geoAdresa+"json"
    
        Alamofire.request(adresa, method: .get, parameters: nil).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    
                    let udaje = odpoved as! NSDictionary
                    var stat, okres, mesto : String
                    
                    stat = ""
                    okres = ""
                    mesto = ""
                    
                    if(udaje.value(forKey: "country") != nil){
                        stat = udaje.value(forKey: "country") as! String
                    }
                    if(udaje.value(forKey: "regionName") != nil){
                        okres = udaje.value(forKey: "regionName") as! String
                    }
                    if(udaje.value(forKey: "city") != nil){
                        mesto = udaje.value(forKey: "city") as! String
                    }
                    
                    if (self.sqliteDatabaza.miestoPrihlasenia()){
                        self.sqliteDatabaza.aktualizujMiestoPrihlasenia(
                            stat: stat,
                            okres: okres,
                            mesto: mesto)
                    }else{
                        self.sqliteDatabaza.noveMiestoPrihlasenia(
                            stat: stat,
                            okres: okres,
                            mesto: mesto)
                    }
                    
                    self.prihlasenie(
                        email: email,
                        heslo: heslo,
                        stat: stat,
                        okres: okres,
                        mesto: mesto)
                }
        }
    }
    
    func registracia(meno: String, email: String, heslo: String, potvrd: String) {
        print("Metoda registracia bola vykonana")

        let adresa = delegate.udalostiAdresa+"udalosti/index.php/registracia"
        let vstup: Parameters=[
            "email":email,
            "meno":meno,
            "heslo":heslo,
            "potvrd":potvrd,
            "nova_registracia":NSUUID().uuidString
        ]
        
        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value {
                    let udaje = odpoved as! NSDictionary
                    let chyba =  udaje.value(forKey: "chyba") as! Bool?
                    
                    if(chyba)!{
                        let validacia = udaje.value(forKey: "validacia") as! NSDictionary
                        if (validacia.value(forKey: "oznam") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "oznam") as! String, od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                        } else if (validacia.value(forKey: "meno") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "meno") as! String, od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                        } else if (validacia.value(forKey: "email") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "email") as! String, od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                        } else if (validacia.value(forKey: "heslo") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "heslo") as! String, od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                        } else if (validacia.value(forKey: "potvrd") != nil){
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: validacia.value(forKey: "potvrd") as! String, od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                        }
                    }else{
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                }
            }
        }
    }
    
    func ulozPrihlasovacieUdajeDoDatabazy(email: String, heslo: String, token: String) {
        print("Metoda ulozPrihlasovacieUdajeDoDatabazy bola vykonana")
        
        if(self.sqliteDatabaza.pouzivatelskeUdaje()){
            self.sqliteDatabaza.aktualizujPouzivatelskeUdaje(
                email: email,
                heslo: heslo,
                token: token)
        }else{
            self.sqliteDatabaza.novePouzivatelskeUdaje(
                email: email,
                heslo: heslo,
                token: token)
        }
    }
    
    func ucetJeNePristupny(email: String) {
        print("Metoda ucetJeNePristupny bola vykonana")
        
        self.sqliteDatabaza.odstranPouzivatelskeUdaje(email: email)
    }
}
