//
//  AutentifikaciaImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol AutentifikaciaImplementacia {

    func miestoPrihlasenia(email: String, heslo: String, zemepisnaSirka: double_t, zemepisnaDlzka: double_t, aktualizuj:Bool) -> Void
	
    func miestoPrihlasenia(email: String, heslo: String) -> Void

    func prihlasenie(email: String, heslo: String) -> Void

    func registracia(meno: String, email: String, heslo:String,potvrd:String) -> Void

    func ulozPrihlasovacieUdajeDoDatabazy(email: String, heslo: String, token: String) -> Void
    
    func ucetJeNePristupny(email:String) -> Void
    
    func vytvorTabulky()
}
