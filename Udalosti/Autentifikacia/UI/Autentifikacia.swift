//
//  Autentifikacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/5/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Autentifikacia: UINavigationController {

    var chyba: Bool?
    var sqliteDatabaza: SQLiteDatabaza!

    func automatickePrihlasenieChyba(){
        print("Metoda automatickePrihlasenieChyba bola vykonana")
        
        if let ucetNepristupny = chyba {
            if ucetNepristupny {
                let chyba = UIAlertController(title: "Chyba", message: "Prosím prihláste sa!", preferredStyle: UIAlertControllerStyle.alert)
                chyba.addAction(UIAlertAction(title: "Zatvoriť", style: UIAlertActionStyle.default, handler: nil))
                self.present(chyba, animated: true, completion: nil)
            }
        }
    }
    
    func vytvorTabulky(){
        print("Metoda vytvorTabulky bola vykonana")

        let preferencie = UserDefaults.standard
        
        if !(preferencie.bool(forKey: "prvyStart")) {
            self.sqliteDatabaza = SQLiteDatabaza()
            self.sqliteDatabaza.vyvorTabulky()
        }
    }
    
    func inicializacia(){
        print("Metoda inicializacia-Autentifikacia bola vykonana")

        self.vytvorTabulky()
    }
    
    override func viewDidLoad() {
        self.inicializacia()
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.automatickePrihlasenieChyba()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
