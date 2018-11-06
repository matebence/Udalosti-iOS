//
//  AutentifikaciaImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol AutentifikaciaImplementacia {
    func ucetJeNePristupny(email:String) -> Void
    func ulozPrihlasovacieUdajeDoDatabazy(email: String, heslo: String, token: String) -> Void
    func miestoPrihlasenia(email: String, heslo: String) -> Void
    func prihlasenie(email: String, heslo: String, stat: String, okres:String, mesto:String) -> Void
    func registracia(meno: String, email: String, heslo:String,potvrd:String) -> Void
}
