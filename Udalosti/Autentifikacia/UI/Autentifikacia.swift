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

    override func viewDidLoad() {
        let preferencie = UserDefaults.standard
        if !(preferencie.bool(forKey: "prvyStart")) {
            self.sqliteDatabaza = SQLiteDatabaza()
            self.sqliteDatabaza.vyvorTabulky()
        }
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.automatickePrihlasenieChyba()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
