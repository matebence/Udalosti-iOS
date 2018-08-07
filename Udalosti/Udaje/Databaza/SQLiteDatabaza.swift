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
    
    var databaza: OpaquePointer?
    let nazovDatabazy:String = "udalosti.sqlite"
    
    init() {
        print("Metoda SQLiteDatabaza bola vykonana")
        
        let miestoUlozenia = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(nazovDatabazy)
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        if sqlite3_exec(databaza,
                        "CREATE TABLE IF NOT EXISTS \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) (\(SQLiteTabulka.Pouzivatel.ID_STLPCA) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLiteTabulka.Pouzivatel.EMAIL) TEXT, \(SQLiteTabulka.Pouzivatel.HESLO) TEXT)", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Pouzivatel")
            return
        }
        
        if sqlite3_exec(databaza,
                        "CREATE TABLE IF NOT EXISTS \(SQLiteTabulka.Miesto.NAZOV_TABULKY) (\(SQLiteTabulka.Miesto.ID_STLPCA) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLiteTabulka.Miesto.STAT) TEXT, \(SQLiteTabulka.Miesto.OKRES) TEXT, \(SQLiteTabulka.Miesto.MESTO) TEXT)", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Miesto")
            return
        }
    }
    
    func noveMiestoPrihlasenia(stat: String, okres:String, mesto:String){
        print("Metoda noveMiestoPrihlasenia bola vykonana")
        
        var stmt: OpaquePointer?
        let dotaz = "INSERT INTO \(SQLiteTabulka.Miesto.NAZOV_TABULKY) (\(SQLiteTabulka.Miesto.STAT), \(SQLiteTabulka.Miesto.OKRES),\(SQLiteTabulka.Miesto.MESTO)) VALUES (?, ?, ?)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba: "+chyba)
            return
        }
        
        if sqlite3_bind_text(stmt, 1, stat, -1, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-Stat pridanie "+chyba)
            return
        }
        if sqlite3_bind_text(stmt, 2, okres, -1, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-Okres pridanie "+chyba)
            return
        }
        if sqlite3_bind_text(stmt, 3, mesto, -1, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-Mesto pridanie "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-pridanie "+chyba)
            return
        }
        print("Nove miesto sa ulozilo")
    }
    
    func aktualizujMiestoPrihlasenia(stat: String, okres: String, mesto:String){
        print("Metoda aktualizujMiestoPrihlasenia bola vykonana")
        
        var stmt: OpaquePointer?
        let idMiestoPrihlasenia = 1;
        let dotaz = "UPDATE \(SQLiteTabulka.Miesto.NAZOV_TABULKY) SET \(SQLiteTabulka.Miesto.STAT) = ?, \(SQLiteTabulka.Miesto.OKRES) = ?, \(SQLiteTabulka.Miesto.MESTO) = ? WHERE \(SQLiteTabulka.Miesto.ID_STLPCA) = \(idMiestoPrihlasenia)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba: "+chyba)
            return
        }
        
        if sqlite3_bind_text(stmt, 1, stat, -1, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-Stat aktualizacia "+chyba)
            return
        }
        if sqlite3_bind_text(stmt, 2, okres, -1, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-Okres aktualizacia "+chyba)
            return
        }
        if sqlite3_bind_text(stmt, 3, mesto, -1, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-Mesto aktualizacia "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-aktualizacia "+chyba)
            return
        }
        print("Miesto sa aktualizovalo")
    }
    
    func miestoPrihlasenia() -> Bool{
        var stmt: OpaquePointer?
        let dotaz = "SELECT * FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba Miesto vypis "+chyba)
            return false
        }
        if(sqlite3_step(stmt) == SQLITE_ROW){
            return true;
        }else{
            return false;
        }
    }
}
