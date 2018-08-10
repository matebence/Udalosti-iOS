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
    private var sqliteDatabaza: SQLiteDatabaza
    
    init(kommunikaciaOdpoved: KommunikaciaOdpoved){
        self.kommunikaciaOdpoved=kommunikaciaOdpoved
        self.sqliteDatabaza = SQLiteDatabaza()
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
