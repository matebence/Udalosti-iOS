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
        self.sqliteDatabaza = SQLiteDatabaza()
    }
    
    func zistiCiPouzivatelExistuje() -> Bool {
        print("Metoda zistiCiPouzivatelExistuje bola vykonana")
        
        return sqliteDatabaza.pouzivatelskeUdaje()
    }
    
    func prihlasPouzivatela() -> NSDictionary {
        print("Metoda prihlasPouzivatela bola vykonana")
        
        return sqliteDatabaza.vratAktualnehoPouzivatela()!
    }
}
