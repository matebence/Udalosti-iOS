//
//  Udalost.swift
//  Udalosti
//
//  Created by Bence Mate on 8/10/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class Udalost {
    
    var idUdalost: String?
    var obrazok: String?
    var nazov: String?
    var den: String?
    var mesiac: String?
    var cas: String?
    var mesto: String?
    var ulica: String?
    
    init(idUdalost: String?, obrazok: String?, nazov: String?, den: String?, mesiac: String?, cas: String?, mesto:String?, ulica:String?) {
        self.idUdalost = idUdalost
        self.obrazok = obrazok;
        self.nazov = nazov
        self.den = den
        self.mesiac = mesiac
        self.cas = cas
        self.mesto = mesto
        self.ulica = ulica
    }
}
