//
//  UdalostiUdaje.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import Alamofire

class UdalostiUdaje : UdalostiImplementacia {
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private var sqliteDatabaza: SQLiteDatabaza

    private var kommunikaciaOdpoved: KommunikaciaOdpoved
    private var kommunikaciaData: KommunikaciaData
    
    init(kommunikaciaOdpoved: KommunikaciaOdpoved, kommunikaciaData: KommunikaciaData){
        print("Metoda init - UdalostiUdaje bola vykonana")

        self.kommunikaciaOdpoved = kommunikaciaOdpoved
        self.kommunikaciaData = kommunikaciaData
        self.sqliteDatabaza = SQLiteDatabaza()
    }
    
    func zoznamUdalosti(email: String, stat: String, token: String) {
        print("Metoda zoznamUdalosti bola vykonana")
        
        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_ZOZNAM_UDALOSTI
        let vstup: Parameters=[
            "email":email,
            "stat":stat,
            "token":token
        ]
        
        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    let udaje = odpoved as! NSDictionary
                    if udaje.value(forKey: "udalosti") != nil{
                        let data: NSArray = udaje.value(forKey: "udalosti") as! NSArray
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.UDALOSTI_OBJAVUJ, data: data)
                    }else{
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.CHYBA, od: Nastavenia.UDALOSTI_OBJAVUJ, data: nil)
                    }
                }else{
                    self.kommunikaciaData.dataZoServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.UDALOSTI_OBJAVUJ, data:nil)
                }
        }
    }
    
    func zoznamUdalostiPodlaPozicie(email: String, stat: String, okres: String, mesto: String, token: String) {
        print("Metoda zoznamUdalostiPodlaPozicie bola vykonana")
        
        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_ZOZNAM_UDALOSTI_PODLA_POZCIE
        let vstup: Parameters=[
            "email":email,
            "stat":stat,
            "okres":okres,
            "mesto":mesto,
            "token":token
        ]

        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    let udaje = odpoved as! NSDictionary
                    
                    if udaje.value(forKey: "udalosti") != nil{
                        let data: NSArray = udaje.value(forKey: "udalosti") as! NSArray
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.UDALOSTI_PODLA_POZICIE, data: data)
                    }else{
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.CHYBA, od: Nastavenia.UDALOSTI_PODLA_POZICIE, data: nil)
                    }
                }else{
                    self.kommunikaciaData.dataZoServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.UDALOSTI_PODLA_POZICIE, data:nil)
                }
        }
    }
    
    func zoznamZaujmov(email: String, token: String) {
        print("Metoda zoznamZaujmov bola vykonana")

        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_ZOZNAM_ZAUJMOV
        let vstup: Parameters=[
            "email":email,
            "token":token
        ]
        
        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    let udaje = odpoved as! NSDictionary
                    
                    if udaje.value(forKey: "udalosti") != nil{
                        let data: NSArray = udaje.value(forKey: "udalosti") as! NSArray
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.ZAUJEM_ZOZNAM, data: data)
                    }else{
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.CHYBA, od: Nastavenia.ZAUJEM_ZOZNAM, data: nil)
                    }
                }else{
                    self.kommunikaciaData.dataZoServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.ZAUJEM_ZOZNAM, data:nil)
                }
        }
    }
    
    func zaujem(email: String, token: String, idUdalost: integer_t) {
        print("Metoda zaujem bola vykonana")

        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_ZAUJEM
        let vstup: Parameters=[
            "email":email,
            "token":token,
            "idUdalost": idUdalost
        ]
        
        Alamofire.request(adresa, method: .get, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    let udaje = odpoved as! NSDictionary
                    
                    if(udaje.value(forKey: "uspech") != nil){
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.ZAUJEM, udaje: udaje)
                    }
                    if(udaje.value(forKey: "chyba") != nil){
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.ZAUJEM, udaje: udaje)
                    }
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.ZAUJEM, udaje:nil)
                }
        }
    }
    
    func potvrdZaujem(email: String, token: String, idUdalost: integer_t) {
        print("Metoda potvrdZaujem bola vykonana")

        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_POTVRD_ZAUJEM
        let vstup: Parameters=[
            "email":email,
            "token":token,
            "idUdalost": idUdalost
        ]
        
        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    let udaje = odpoved as! NSDictionary
                    
                    if udaje.value(forKey: "udalosti") != nil{
                        let data: NSArray = udaje.value(forKey: "udalosti") as! NSArray
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.ZAUJEM_POTVRD, data: data)
                    }else{
                        self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.CHYBA, od: Nastavenia.ZAUJEM_POTVRD, data: nil)
                    }
                }else{
                    self.kommunikaciaData.dataZoServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.ZAUJEM_POTVRD, data:nil)
                }
        }
    }
    
    func odstranZaujem(email: String, token: String, idUdalost: integer_t) {
        print("Metoda odstranZaujem bola vykonana")

        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_ODSTRAN_ZAUJEM
        let vstup: Parameters=[
            "email":email,
            "token":token,
            "idUdalost": idUdalost
        ]
        
        Alamofire.request(adresa, method: .get, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value{
                    let udaje = odpoved as! NSDictionary
                    
                    if(udaje.value(forKey: "uspech") != nil){
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.ZAUJEM_ODSTRANENIE, udaje: udaje)
                    }
                    if(udaje.value(forKey: "chyba") != nil){
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.ZAUJEM_ODSTRANENIE, udaje: udaje)
                    }
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.ZAUJEM_ODSTRANENIE, udaje:nil)
                }
        }
    }
    
    func miestoPrihlasenia() -> NSDictionary {
        print("Metoda miestoPrihlasenia bola vykonana")
        
        let miesto: NSDictionary = sqliteDatabaza.varMiesto()!
        return miesto
    }
    
    func odhlasenie(email: String) {
        print("Metoda odhlasenie bola vykonana")
        
        let adresa = delegate.udalostiAdresa+Nastavenia.SERVER_ODHLASENIE
        let vstup: Parameters=[
            "email":email
        ]
        
        Alamofire.request(adresa, method: .post, parameters: vstup).responseJSON
            {
                response in
                if let odpoved = response.result.value {
                    let udaje = odpoved as! NSDictionary
                    let chyba =  udaje.value(forKey: "chyba") as! Bool?
                    
                    if(chyba)!{
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: "Pri odhlaseni nastala chyba", od: Nastavenia.AUTENTIFIKACIA_ODHLASENIE, udaje:nil)
                    }else{
                        self.kommunikaciaOdpoved.odpovedServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.AUTENTIFIKACIA_ODHLASENIE, udaje:nil)
                    }
                }else{
                    self.kommunikaciaOdpoved.odpovedServera(odpoved: "Server je momentalne nedostupný!", od: Nastavenia.AUTENTIFIKACIA_ODHLASENIE, udaje:nil)
                }
        }
    }
    
    func automatickePrihlasenieVypnute(email: String) {
        print("Metoda automatickePrihlasenieVypnute bola vykonana")
        
        sqliteDatabaza.odstranPouzivatela(email: email)
    }
}
