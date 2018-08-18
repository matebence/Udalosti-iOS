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
    
    private var databaza: OpaquePointer?
    private var miestoUlozenia: URL
    private let nazovDatabazy:String = "udalosti.sqlite"
    
    init() {
        print("Metoda SQLiteDatabaza bola vykonana")
        
        miestoUlozenia = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(nazovDatabazy)
    }
    
    func vyvorTabulky(){
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        if sqlite3_exec(databaza,
                        "CREATE TABLE IF NOT EXISTS \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) (\(SQLiteTabulka.Pouzivatel.ID_STLPCA) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLiteTabulka.Pouzivatel.EMAIL) TEXT, \(SQLiteTabulka.Pouzivatel.HESLO) TEXT, \(SQLiteTabulka.Pouzivatel.TOKEN))", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Pouzivatel")
            return
        }
        
        if sqlite3_exec(databaza,
                        "CREATE TABLE IF NOT EXISTS \(SQLiteTabulka.Miesto.NAZOV_TABULKY) (\(SQLiteTabulka.Miesto.ID_STLPCA) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLiteTabulka.Miesto.STAT) TEXT, \(SQLiteTabulka.Miesto.OKRES) TEXT, \(SQLiteTabulka.Miesto.MESTO) TEXT)", nil, nil, nil) != SQLITE_OK {
            print("Nastala chyba pri vyvorenie tabulky Miesto")
            return
        }
        
        sqlite3_close(databaza)
    }
    
    func noveMiestoPrihlasenia(stat: String, okres:String, mesto:String){
        print("Metoda noveMiestoPrihlasenia bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "INSERT INTO \(SQLiteTabulka.Miesto.NAZOV_TABULKY) (\(SQLiteTabulka.Miesto.STAT), \(SQLiteTabulka.Miesto.OKRES),\(SQLiteTabulka.Miesto.MESTO)) VALUES ('\(stat)', '\(okres)', '\(mesto)')"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba pridavanie(Miesto): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-pridanie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        print("Nove miesto sa ulozilo")
    }
    
    func aktualizujMiestoPrihlasenia(stat: String, okres: String, mesto:String){
        print("Metoda aktualizujMiestoPrihlasenia bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let idMiestoPrihlasenia = 1;
        let dotaz = "UPDATE \(SQLiteTabulka.Miesto.NAZOV_TABULKY) SET \(SQLiteTabulka.Miesto.STAT) = '\(stat)', \(SQLiteTabulka.Miesto.OKRES) = '\(okres)', \(SQLiteTabulka.Miesto.MESTO) = '\(mesto)' WHERE \(SQLiteTabulka.Miesto.ID_STLPCA) = \(idMiestoPrihlasenia)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba aktualizacia(Miesto): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Miesto-aktualizacia: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        print("Miesto sa aktualizovalo")
    }
    
    func odstranMiestoPrihlasenia(idMiesto: integer_t){
        print("Metoda aktualizujMiestoPrihlasenia bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "DELETE FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY) WHERE \(SQLiteTabulka.Miesto.ID_STLPCA) = \(idMiesto)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba odstranenie(Miesto): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba Miesto-odstranenie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)

        print("Miesto prihlasenia sa odstranilo")
    }
    
    func miestoPrihlasenia() -> Bool{
        print("Metoda miestoPrihlasenia bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return false
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT * FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba Miesto riadok: "+chyba)
            return false
        }
        
        if(sqlite3_step(stmt) == SQLITE_ROW){
            sqlite3_finalize(stmt)
            sqlite3_close(databaza)
            
            return true;
        }else{
            sqlite3_finalize(stmt)
            sqlite3_close(databaza)
            
            return false;
        }
    }
    
    func vratMiestoPrihlasenia() -> NSDictionary? {
        print("Metoda vratMiestoPrihlasenia bola vykonana")

        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return nil
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT \(SQLiteTabulka.Miesto.STAT), \(SQLiteTabulka.Miesto.OKRES), \(SQLiteTabulka.Miesto.MESTO) FROM \(SQLiteTabulka.Miesto.NAZOV_TABULKY)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba Miesto vypis: "+chyba)
            return nil
        }
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let stat = String(cString: sqlite3_column_text(stmt, 0))
            let okres = String(cString: sqlite3_column_text(stmt, 1))
            let mesto = String(cString: sqlite3_column_text(stmt, 2))
            
            let udaje: NSDictionary = [
                "stat": stat,
                "okres": okres,
                "mesto": mesto
            ]
            sqlite3_finalize(stmt)
            sqlite3_close(databaza)
            
            return udaje
        }
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        return nil
    }
    
    func novePouzivatelskeUdaje(email:String, heslo:String, token:String){
        print("Metoda novePouzivatelskeUdaje bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "INSERT INTO \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) (\(SQLiteTabulka.Pouzivatel.EMAIL), \(SQLiteTabulka.Pouzivatel.HESLO), \(SQLiteTabulka.Pouzivatel.TOKEN)) VALUES ('\(email)', '\(heslo)', '\(token)')"

        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba pridavanie(Pouzivatel): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Pouzivatel-pridanie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        print("Nove Pouzivatelske udaje sa ulozili")
    }
    
    func aktualizujPouzivatelskeUdaje(email:String, heslo:String, token:String){
        print("Metoda aktualizujPouzivatelskeUdaje bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "UPDATE \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) SET \(SQLiteTabulka.Pouzivatel.EMAIL) = '\(email)', \(SQLiteTabulka.Pouzivatel.HESLO) = '\(heslo)', \(SQLiteTabulka.Pouzivatel.TOKEN) = '\(token)'  WHERE \(SQLiteTabulka.Pouzivatel.EMAIL) = '\(email)'"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba aktualizacia(Pouzivatel): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databa chyba Pouzivatel-aktualizacia: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        print("Pouzivatelske udaje sa aktualizovali")
    }
    
    func odstranPouzivatelskeUdaje(email: String){
        print("Metoda odstranPouzivatelskeUdaje bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return
        }
        
        var stmt: OpaquePointer?
        let dotaz = "DELETE FROM \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY) WHERE \(SQLiteTabulka.Pouzivatel.EMAIL) = '\(email)'"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba odstranenie(Pouzivatel): "+chyba)
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba Pouzivatel-odstranenie: "+chyba)
            return
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        print("Pouzivatelske udaje sa odstranili")
    }
    
    func pouzivatelskeUdaje() -> Bool{
        print("Metoda pouzivatelskeUdaje bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return false
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT * FROM \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK {
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
            print("Databaza chyba Pouzivatel riadok: "+chyba)
            return false
        }
        if(sqlite3_step(stmt) == SQLITE_ROW){
            sqlite3_finalize(stmt)
            sqlite3_close(databaza)
            
            return true;
        }else{
            sqlite3_finalize(stmt)
            sqlite3_close(databaza)

            return false;
        }
    }
    
    func vratAktualnehoPouzivatela() -> NSDictionary?{
        print("Metoda vratAktualnehoPouzivatela bola vykonana")
        
        if sqlite3_open(miestoUlozenia.path, &databaza) != SQLITE_OK {
            print("Databazu sa nepodarilo otvorit")
            return nil
        }
        
        var stmt: OpaquePointer?
        let dotaz = "SELECT \(SQLiteTabulka.Pouzivatel.EMAIL), \(SQLiteTabulka.Pouzivatel.HESLO), \(SQLiteTabulka.Pouzivatel.TOKEN) FROM \(SQLiteTabulka.Pouzivatel.NAZOV_TABULKY)"
        
        if sqlite3_prepare(databaza, dotaz, -1, &stmt, nil) != SQLITE_OK{
            let chyba = String(cString: sqlite3_errmsg(databaza)!)
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
            sqlite3_close(databaza)
            
            return udaje
        }
        sqlite3_finalize(stmt)
        sqlite3_close(databaza)
        
        return nil
    }
}
