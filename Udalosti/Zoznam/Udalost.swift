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
    var datum: String?
    var cas: String?
    var miesto: String?
    
    init(idUdalost: String?, obrazok: String?, nazov: String?, datum: String?, cas: String?, miesto:String?) {
        self.idUdalost = idUdalost
        self.obrazok = obrazok;
        self.nazov = nazov
        self.datum = datum
        self.cas = cas
        self.miesto = miesto
    }
}
