//
//  SQLiteDatabaza.swift
//  Udalosti
//
//  Created by Bence Mate on 8/7/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabaza {
    
    let nazovDatabazy:String = "udalosti.sqlite"
    
    init() {
        var databaza: OpaquePointer?
        let miestoUlozenia = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(nazovDatabazy)
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        if sqlite3_exec(databaza,
                        "CREATE TABLE IF NOT EXISTS "+SQLiteTabulka.Pouzivatel.NAZOV_TABULKY+" ("+SQLiteTabulka.Pouzivatel.ID_STLPCA+" INTEGER PRIMARY KEY AUTOINCREMENT, "+SQLiteTabulka.Pouzivatel.EMAIL+" VARCHAR(255), "+SQLiteTabulka.Pouzivatel.HESLO+" VARCHAR(128))", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Pouzivatel")
            return
        }
        
        if sqlite3_exec(databaza,
                        "CREATE TABLE IF NOT EXISTS "+SQLiteTabulka.Miesto.NAZOV_TABULKY+" ("+SQLiteTabulka.Miesto.ID_STLPCA+" INTEGER PRIMARY KEY AUTOINCREMENT, "+SQLiteTabulka.Miesto.STAT+" VARCHAR(30), "+SQLiteTabulka.Miesto.OKRES+" VARCHAR(30), "+SQLiteTabulka.Miesto.MESTO+" VARCHAR(30))", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Miesto")
            return
        }
    }
    
    
}
