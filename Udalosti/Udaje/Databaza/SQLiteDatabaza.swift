//
//  SQLiteDatabaza.swift
//  Udalosti
//
//  Created by Bence Mate on 8/7/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import SQLite3

class SQLiteDatabaza: SQLiteDataImplementacia {
   
    private let nazovDatabazy:String = "udalosti.sqlite"
    private var databaza: OpaquePointer?
    private var miestoUlozenia: URL

    init() {
        print("Metoda init - SQLiteDatabaza bola vykonana")
        
        self.miestoUlozenia = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(self.nazovDatabazy)
    }
    
    func vytvor() {
        print("Metoda vytvor bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        if sqlite3_exec(self.databaza,
                        "CREATE TABLE IF NOT EXISTS \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) (\(SQLiteTabulka.Pouzivatel.ID_STLPCA) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLiteTabulka.Pouzivatel.EMAIL) TEXT, \(SQLiteTabulka.Pouzivatel.HESLO) TEXT, \(SQLiteTabulka.Pouzivatel.TOKEN))", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Pouzivatel")
            return
        }
        
        if sqlite3_exec(self.databaza,
                        "CREATE TABLE IF NOT EXISTS \(SQLiteTabulka.Miesto.NAZOV_TABULKY) (\(SQLiteTabulka.Miesto.ID_STLPCA) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLiteTabulka.Miesto.POZICIA) TEXT, \(SQLiteTabulka.Miesto.OKRES) TEXT, \(SQLiteTabulka.Miesto.KRAJ) TEXT, \(SQLiteTabulka.Miesto.PSC) TEXT, \(SQLiteTabulka.Miesto.STAT) TEXT, \(SQLiteTabulka.Miesto.ZNAKSTATU) TEXT)", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Miesto")
            return
        }
        
        sqlite3_close(self.databaza)
    }

    func noveMiesto(pozicia: String, okres:String, kraj:String, psc:String, stat:String, znakStatu:String) {
        print("Metoda noveMiesto bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "INSERT INTO \(SQLiteTabulka.Miesto.NAZOV_TABULKY) (\(SQLiteTabulka.Miesto.POZICIA), \(SQLiteTabulka.Miesto.OKRES), \(SQLiteTabulka.Miesto.KRAJ), \(SQLiteTabulka.Miesto.PSC), \(SQLiteTabulka.Miesto.STAT), \(SQLiteTabulka.Miesto.ZNAKSTATU)) VALUES ('\(pozicia)', '\(okres)', '\(kraj)', '\(psc)', '\(stat)', '\(znakStatu)')"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba pridavanie(Miesto): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databa chyba Miesto-pridanie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        print("Nove miesto sa ulozilo")
    }

    func aktualizujMiesto(pozicia: String, okres:String, kraj:String, psc:String, stat:String, znakStatu:String) {
        print("Metoda aktualizujMiesto bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let idMiestoPrihlasenia = 1;
        let dotaz = "UPDATE \(SQLiteTabulka.Miesto.NAZOV_TABULKY) SET \(SQLiteTabulka.Miesto.POZICIA) = '\(pozicia)', \(SQLiteTabulka.Miesto.OKRES) = '\(okres)', \(SQLiteTabulka.Miesto.KRAJ) = '\(kraj)', \(SQLiteTabulka.Miesto.PSC) = '\(psc)', \(SQLiteTabulka.Miesto.STAT) = '\(stat)', \(SQLiteTabulka.Miesto.ZNAKSTATU) = '\(znakStatu)' WHERE \(SQLiteTabulka.Miesto.ID_STLPCA) = \(idMiestoPrihlasenia)"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba aktualizacia(Miesto): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databa chyba Miesto-aktualizacia: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        print("Miesto sa aktualizovalo")
    }

    func odstrnaMiesto(idMiesto: integer_t) {
        print("Metoda odstranMiesto bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "DELETE FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY) WHERE \(SQLiteTabulka.Miesto.ID_STLPCA) = \(idMiesto)"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba odstranenie(Miesto): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba Miesto-odstranenie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        print("Miesto prihlasenia sa odstranilo")
    }

    func miesto() -> Bool {
        print("Metoda miesto bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return false
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT * FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY)"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK {
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba Miesto riadok: "+chyba)
            return false
        }
        
        if(sqlite3_step(stmt) == SQLITE_ROW){
            sqlite3_finalize(stmt)
            sqlite3_close(self.databaza)
            
            return true;
        }else{
            sqlite3_finalize(stmt)
            sqlite3_close(self.databaza)
            
            return false;
        }
    }

    func varMiesto() -> NSDictionary? {
        print("Metoda vratMiesto bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return nil
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT \(SQLiteTabulka.Miesto.POZICIA), \(SQLiteTabulka.Miesto.OKRES), \(SQLiteTabulka.Miesto.KRAJ), \(SQLiteTabulka.Miesto.PSC), \(SQLiteTabulka.Miesto.STAT), \(SQLiteTabulka.Miesto.ZNAKSTATU) FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY)"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba Miesto vypis: "+chyba)
            return nil
        }
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let pozicia = String(cString: sqlite3_column_text(stmt, 0))
            let okres = String(cString: sqlite3_column_text(stmt, 1))
            let kraj = String(cString: sqlite3_column_text(stmt, 2))
            let psc = String(cString: sqlite3_column_text(stmt, 3))
            let stat = String(cString: sqlite3_column_text(stmt, 4))
            let znakStatu = String(cString: sqlite3_column_text(stmt, 5))

            let udaje: NSDictionary = [
                "pozicia": pozicia,
                "okres": okres,
                "kraj": kraj,
                "psc": psc,
                "stat": stat,
                "znakStatu": znakStatu
            ]
            sqlite3_finalize(stmt)
            sqlite3_close(self.databaza)
            
            return udaje
        }
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        return nil
    }

    func novyPouzivatel(email: String, heslo: String, token: String) {
        print("Metoda novyPouzivatel bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "INSERT INTO \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) (\(SQLiteTabulka.Pouzivatel.EMAIL), \(SQLiteTabulka.Pouzivatel.HESLO), \(SQLiteTabulka.Pouzivatel.TOKEN)) VALUES ('\(email)', '\(heslo)', '\(token)')"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba pridavanie(Pouzivatel): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databa chyba Pouzivatel-pridanie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        print("Nove Pouzivatelske udaje sa ulozili")
    }

    func aktualizujPouzivatela(email: String, heslo: String, token: String) {
        print("Metoda aktualizujPouzivatela bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "UPDATE \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) SET \(SQLiteTabulka.Pouzivatel.EMAIL) = '\(email)', \(SQLiteTabulka.Pouzivatel.HESLO) = '\(heslo)', \(SQLiteTabulka.Pouzivatel.TOKEN) = '\(token)'  WHERE \(SQLiteTabulka.Pouzivatel.EMAIL) = '\(email)'"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba aktualizacia(Pouzivatel): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databa chyba Pouzivatel-aktualizacia: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        print("Pouzivatelske udaje sa aktualizovali")
    }

    func odstranPouzivatela(email: String) {
        print("Metoda odstranPouzivatela bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "DELETE FROM \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) WHERE \(SQLiteTabulka.Pouzivatel.EMAIL) = '\(email)'"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba odstranenie(Pouzivatel): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba Pouzivatel-odstranenie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        print("Pouzivatelske udaje sa odstranili")
    }

    func pouzivatel() -> Bool {
        print("Metoda pouzivatel bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return false
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT * FROM \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY)"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK {
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba Pouzivatel riadok: "+chyba)
            return false
        }
        if(sqlite3_step(stmt) == SQLITE_ROW){
            sqlite3_finalize(stmt)
            sqlite3_close(self.databaza)
            
            return true;
        }else{
            sqlite3_finalize(stmt)
            sqlite3_close(self.databaza)
            
            return false;
        }
    }

    func vratPouzivatela() -> NSDictionary? {
        print("Metoda vratPouzivatela bola vykonana")
        
        if sqlite3_open(self.miestoUlozenia.path, &self.databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return nil
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT \(SQLiteTabulka.Pouzivatel.EMAIL), \(SQLiteTabulka.Pouzivatel.HESLO), \(SQLiteTabulka.Pouzivatel.TOKEN) FROM \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY)"
        
        if sqlite3_prepare(self.databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(self.databaza)!)
            print("Databaza chyba Pouzivatel vypis: "+chyba)
            return nil
        }
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let email = String(cString: sqlite3_column_text(stmt, 0))
            let heslo = String(cString: sqlite3_column_text(stmt, 1))
            let token = String(cString: sqlite3_column_text(stmt, 2))
            
            let udaje: NSDictionary = [
                "email": email,
                "heslo": heslo,
                "token": token
            ]
            sqlite3_finalize(stmt)
            sqlite3_close(self.databaza)
            
            return udaje
        }
        sqlite3_finalize(stmt)
        sqlite3_close(self.databaza)
        
        return nil
    }
}
