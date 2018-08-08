//
//  SQLiteTabulka.swift
//  Udalosti
//
//  Created by Bence Mate on 8/7/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
class SQLiteTabulka{
    class Miesto{
        static let NAZOV_TABULKY: String = "miesto"
        static let ID_STLPCA: String = "id"
        static let STAT: String = "stat"
        static let OKRES: String = "okres"
        static let MESTO: String = "mesto"
    }
    
    class Pouzivatel{
        static let NAZOV_TABULKY: String = "pouzivatel"
        static let ID_STLPCA: String = "id"
        static let EMAIL: String = "email"
        static let HESLO: String = "heslo"
        static let TOKEN: String = "token"
    }
}
