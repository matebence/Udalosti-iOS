//
//  SQLiteDataImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/18/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol SQLiteDataImplementacia{
    func vyvorTabulky()
    func noveMiestoPrihlasenia(stat: String, okres:String, mesto:String)
    func aktualizujMiestoPrihlasenia(stat: String, okres: String, mesto:String)
    func odstranMiestoPrihlasenia(idMiesto: integer_t)
    func miestoPrihlasenia() -> Bool
    func vratMiestoPrihlasenia() -> NSDictionary?
    func novePouzivatelskeUdaje(email:String, heslo:String, token:String)
    func aktualizujPouzivatelskeUdaje(email:String, heslo:String, token:String)
    func odstranPouzivatelskeUdaje(email: String)
    func pouzivatelskeUdaje() -> Bool
    func vratAktualnehoPouzivatela() -> NSDictionary?
}
