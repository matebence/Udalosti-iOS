//
//  Autentifikacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/5/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Autentifikacia: UINavigationController, KommunikaciaOdpoved {

    var autentifikaciaUdaje : AutentifikaciaUdaje!
    var chyba: Bool?
    
    override func viewDidAppear(_ animated: Bool) {
        print("Metoda viewDidAppear - Autentifikacia bola vykonana")

        self.automatickePrihlasenieChyba()
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - Autentifikacia bola vykonana")

        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - Autentifikacia bola vykonana")

        super.viewDidLoad()
        inicializacia()
    }

    func inicializacia(){
        print("Metoda inicializacia-Autentifikacia bola vykonana")
        
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        self.autentifikaciaUdaje.vytvorTabulky()
    }
    
    func automatickePrihlasenieChyba(){
        print("Metoda automatickePrihlasenieChyba bola vykonana")
        
        if let ucetNepristupny = self.chyba {
            if ucetNepristupny {
                let chyba = UIAlertController(title: "Chyba", message: "Prosím prihláste sa!", preferredStyle: UIAlertController.Style.alert)
                chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertAction.Style.default, handler: nil))
                self.present(chyba, animated: true, completion: nil)
            }
        }
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Autentifikacia bola vykonana")
    }
}
