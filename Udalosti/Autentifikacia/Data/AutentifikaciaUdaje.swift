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
    
    init(kommunikaciaOdpoved: KommunikaciaOdpoved){
        self.kommunikaciaOdpoved=kommunikaciaOdpoved
    }
    
    func prihlasenie(email: String, heslo: String, stat: String, okres: String, mesto: String) {
        let adresa = delegate.udalostiAdresa+"udalosti/index.php/prihlasenie"
        let vstup: Parameters=[
            "email":email,
            "heslo":heslo,
            "pokus_o_prihlasenie":NSUUID().uuidString
        ]
    }
    
    func miestoPrihlasenia(email: String, heslo: String) {
        let adresa = delegate.geoAdresa
    }
    
    func registracia(meno: String, email: String, heslo: String, potvrd: String) {
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
    
    func ulozPrihlasovacieUdajeDoDatabazy(email: String, heslo: String) {
        <#code#>
    }
    
    func ucetJeNePristupny(email: String) {
        <#code#>
    }
}
