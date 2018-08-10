//
//  UdalostiUdaje.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import Alamofire

class UdalostiUdaje : UdalostiImplementacia{
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private var kommunikaciaOdpoved: KommunikaciaOdpoved
    private var kommunikaciaData: KommunikaciaData
    private var sqliteDatabaza: SQLiteDatabaza
    
    init(kommunikaciaOdpoved: KommunikaciaOdpoved, kommunikaciaData: KommunikaciaData){
        self.kommunikaciaOdpoved = kommunikaciaOdpoved
        self.kommunikaciaData = kommunikaciaData
        self.sqliteDatabaza = SQLiteDatabaza()
    }
    
    func zoznamUdalosti(email: String, stat: String, token: String) {
        print("Metoda zoznamUdalosti bola vykonana")
        
        let adresa = delegate.udalostiAdresa+"udalosti/index.php/udalosti"
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
                    let data: NSArray = udaje.value(forKey: "udalosti") as! NSArray
                    
                    self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.UDALOSTI, data: data)
                }
        }
    }
    
    func zoznamUdalostiPodlaPozicie(email: String, stat: String, okres: String, mesto: String, token: String) {
        print("Metoda zoznamUdalostiPodlaPozicie bola vykonana")
        
        let adresa = delegate.udalostiAdresa+"udalosti/index.php/udalosti/udalosti_podla_pozicie"
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
                    let data: NSArray = udaje.value(forKey: "udalosti") as! NSArray
                    
                    self.kommunikaciaData.dataZoServera(odpoved: Nastavenia.VSETKO_V_PORIADKU, od: Nastavenia.UDALOSTI_PODLA_POZICIE, data: data)
                }
        }
    }
    
    func odhlasenie(email: String) {
        print("Metoda odhlasenie bola vykonana")
        
        let adresa = delegate.udalostiAdresa+"udalosti/index.php/prihlasenie/odhlasit_sa"
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
                }
        }
    }
    
    func automatickePrihlasenieVypnute(email: String) {
        print("Metoda automatickePrihlasenieVypnute bola vykonana")
        
        sqliteDatabaza.odstranPouzivatelskeUdaje(email: email)
    }

    func miestoPrihlasenia() -> NSDictionary {
        print("Metoda miestoPrihlasenia bola vykonana")
        
        let miesto: NSDictionary = sqliteDatabaza.vratMiestoPrihlasenia()!
        return miesto
    }
}