//
//  UdalostiImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol UdalostiImplementacia {
    
    func zoznamUdalosti(email: String, stat: String, token: String)
    
    func zoznamUdalostiPodlaPozicie(email: String, stat: String, okres: String, mesto: String, token: String)
    
    func zoznamZaujmov(email: String, token:String)
    
    func zaujem(email: String, token:String, idUdalost:integer_t)
    
    func potvrdZaujem(email:String, token:String, idUdalost:integer_t)
    
    func odstranZaujem(email:String, token:String, idUdalost:integer_t)
    
    func miestoPrihlasenia() -> NSDictionary

    func odhlasenie(email: String)

    func automatickePrihlasenieVypnute(email: String)
}
