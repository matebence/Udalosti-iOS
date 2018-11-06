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
    func automatickePrihlasenieVypnute(email: String)
    func odhlasenie(email: String)
    func miestoPrihlasenia() -> NSDictionary
}
