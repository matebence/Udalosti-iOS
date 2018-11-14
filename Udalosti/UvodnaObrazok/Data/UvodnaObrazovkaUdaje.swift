//
//  UvodnaObrazovkaUdaje.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class UvodnaObrazovkaUdaje : UvodnaObrazovkaImplementacia{

    private var sqliteDatabaza: SQLiteDatabaza
    
    init() {
        print("Metoda init - UvodnaObrazovkaUdaje bola vykonana")

        self.sqliteDatabaza = SQLiteDatabaza()
    }
    
    func zistiCiPouzivatelExistuje() -> Bool {
        print("Metoda zistiCiPouzivatelExistuje bola vykonana")
        
        return self.sqliteDatabaza.pouzivatel()
    }
    
    func prihlasPouzivatela() -> NSDictionary {
        print("Metoda prihlasPouzivatela bola vykonana")
        
        return self.sqliteDatabaza.vratPouzivatela()!
    }
}
