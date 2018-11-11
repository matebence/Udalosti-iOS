//
//  SQLiteDataImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/18/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol SQLiteDataImplementacia{
    
    func vytvor()
    
    func noveMiesto(pozicia: String, okres:String, kraj:String, psc:String, stat:String, znakStatu:String)
    
    func aktualizujMiesto(pozicia: String, okres:String, kraj:String, psc:String, stat:String, znakStatu:String)
    
    func odstrnaMiesto(idMiesto: integer_t)
    
    func miesto() -> Bool
    
    func varMiesto() -> NSDictionary?
    
    func novyPouzivatel(email:String, heslo:String, token:String)
    
    func aktualizujPouzivatela(email:String, heslo:String, token:String)
    
    func odstranPouzivatela(email: String)
    
    func pouzivatel() -> Bool
    
    func vratPouzivatela() -> NSDictionary?
}
