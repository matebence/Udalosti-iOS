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
        print("Metoda init - AutentifikaciaUdaje bola vykonana")

        self.kommunikaciaOdpoved=kommunikaciaOdpoved
        self.sqliteDatabaza = SQLiteDatabaza()
    }

    func miestoPrihlasenia(email: String, heslo: String, zemepisnaSirka: double_t, zemepisnaDlzka: double_t, aktualizuj: Bool) {
        print("Metoda miestoPrihlasenia bola vykonana")

        let adresa = "\(delegate.geoAdresa)&lat=\(zemepisnaSirka)&lon=\(zemepisnaDlzka)&format=\(Nastavenia.POZICIA_FORMAT)&accept-language=\(Nastavenia.POZICIA_JAZYK)"

        Alamofire.request(adresa, method: .get, parameters: nil).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    
                    let udaje = odpoved as! NSDictionary
                    var pozicia, okres, kraj, psc, stat, znakStatu:String
                    
                    pozicia = ""
                    okres = ""
                    kraj = ""
                    psc = ""
                    stat = ""
                    znakStatu = ""
                    
                    if(udaje.value(forKey: "city_district") != nil){
                        pozicia = udaje.value(forKey: "city_district") as! String
                    }
                    if(udaje.value(forKey: "city") != nil){
                        okres = udaje.value(forKey: "city") as! String
                    }
                    if(udaje.value(forKey: "state") != nil){
                        kraj = udaje.value(forKey: "state") as! String
                    }
                    if(udaje.value(forKey: "postcode") != nil){
                        psc = udaje.value(forKey: "postcode") as! String
                    }
                    if(udaje.value(forKey: "country") != nil){
                        stat = udaje.value(forKey: "country") as! String
                    }
                    if(udaje.value(forKey: "country_code") != nil){
                        znakStatu = udaje.value(forKey: "country_code") as! String
                    }
                    
                    if (self.sqliteDatabaza.miesto()){
                        self.sqliteDatabaza.aktualizujMiesto(
                            pozicia: pozicia,
                            okres: okres,
                            kraj: kraj,
                            psc: psc,
                            stat: stat,
                            znakStatu: znakStatu)
                    }else{
                        self.sqliteDatabaza.noveMiesto(
                            pozicia: pozicia,
                            okres: okres,
                            kraj: kraj,
                            psc: psc,
                            stat: stat,
                            znakStatu: znakStatu)
                    }
                    
                    if(aktualizuj){
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.UDALOSTI_AKTUALIZUJ, udaje:nil)
                    }else{
                        self.prihlasenie(
                            email: email,
                            heslo: heslo)
                    }
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:nil)
                }
        }
    }		
    
    func miestoPrihlasenia(email: String, heslo: String) {
        print("Metoda miestoPrihlasenia bola vykonana")
        
        let adresa = delegate.ipAdresa+Nastavenia.SERVER_GEO_IP
        
        Alamofire.request(adresa, method: .get, parameters: nil).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    
                    let udaje = odpoved as! NSDictionary
                    var stat:String = ""
                    
                    if(udaje.value(forKey: "country") != nil){
                        stat = udaje.value(forKey: "country") as! String
                        stat = "Slovensko"
                    }
                    
                    if (self.sqliteDatabaza.miesto()){
                        self.sqliteDatabaza.aktualizujMiesto(
                            pozicia: "",
                            okres: "",
                            kraj: "",
                            psc: "",
                            stat: stat,
                            znakStatu: "")
                    }else{
                        self.sqliteDatabaza.noveMiesto(
                            pozicia: "",
                            okres: "",
                            kraj: "",
                            psc: "",
                            stat: stat,
                            znakStatu: "")
                    }
                    
                    self.prihlasenie(
                        email: email,
                        heslo: heslo)
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:nil)
                }
        }
    }
    
    func prihlasenie(email: String, heslo: String) {
        print("Metoda prihlasenie bola vykonana")
        
        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_PRIHLASENIE
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
                        if udaje.value(forKey: "pouzivatel") != nil{
                            let pouzivatel = udaje.value(forKey: "pouzivatel") as! NSDictionary
                            
                            data["heslo"] = heslo
                            data["token"] = pouzivatel.value(forKey: "token") as! String
                            
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:data)
                        }else{
                            self.kommunikaciaOdpoved.odpovedServera(odpoved: "Údaje sa nepodarilo spracovať. Prosím skúste ešte raz!", od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:nil)
                        }
                    }
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.AUTENTIFIKACIA_PRIHLASENIE, udaje:nil)
                }
        }
    }
    
    func registracia(meno: String, email: String, heslo: String, potvrd: String) {
        print("Metoda registracia bola vykonana")

        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_REGISTRACIA
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
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.AUTENTIFIKACIA_REGISRACIA, udaje:nil)
                }
        }
    }
    
    func ulozPrihlasovacieUdajeDoDatabazy(email: String, heslo: String, token: String) {
        print("Metoda ulozPrihlasovacieUdajeDoDatabazy bola vykonana")
        
        if(self.sqliteDatabaza.pouzivatel()){
            self.sqliteDatabaza.aktualizujPouzivatela(
                email: email,
                heslo: heslo,
                token: token)
        }else{
            self.sqliteDatabaza.novyPouzivatel(
                email: email,
                heslo: heslo,
                token: token)
        }
    }
    
    func ucetJeNePristupny(email: String) {
        print("Metoda ucetJeNePristupny bola vykonana")
        
        self.sqliteDatabaza.odstranPouzivatela(email: email)
    }
    
    func vytvorTabulky() {
        print("Metoda vytvorTabulky bola vykonana")

        let preferencie = UserDefaults.standard
        
        if !(preferencie.bool(forKey: "prvyStart")) {
            self.sqliteDatabaza = SQLiteDatabaza()
            self.sqliteDatabaza.vytvor()
        }
    }
}
