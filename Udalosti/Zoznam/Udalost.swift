//
//  Udalost.swift
//  Udalosti
//
//  Created by Bence Mate on 8/10/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class Udalost {
    
    var idUdalost: integer_t?
    var obrazok: String?
    var nazov: String?
    var den: String?
    var mesiac: String?
    var cas: String?
    var mesto: String?
    var ulica: String?
    var vstupenka: float_t?
    var zaujemcovia: integer_t?
    var zaujem: integer_t?
    
    init(idUdalost: integer_t?, obrazok: String?, nazov: String?, den: String?, mesiac: String?, cas: String?, mesto:String?, ulica:String?, vstupenka: float_t, zaujemcovia:integer_t, zaujem:integer_t) {
        self.idUdalost = idUdalost
        self.obrazok = obrazok;
        self.nazov = nazov
        self.den = den
        self.mesiac = mesiac
        self.cas = cas
        self.mesto = mesto
        self.ulica = ulica
        self.vstupenka = vstupenka
        self.zaujemcovia = zaujemcovia
        self.zaujem = zaujem
    }
}
