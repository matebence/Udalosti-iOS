//
//  Retazec.swift
//  Udalosti
//
//  Created by Bence Mate on 8/11/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

extension String{
    func pozicia(od: Int) -> Index{
        print("Metoda pozicia bola vykonana")
        
        return self.index(startIndex, offsetBy: od)
    }
    
    func castRetazca(doRetazca: Int) -> String {
        print("Metoda castRetazca bola vykonana")
        
        let retazecDo = pozicia(od: doRetazca)
        return String(self[..<retazecDo])
    }
}
