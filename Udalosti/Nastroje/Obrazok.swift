//
//  Obrazok.swift
//  Udalosti
//
//  Created by Bence Mate on 8/11/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
import UIKit

class Obrazok {
    static func nastavObrazok(_ obrazok: UIImage?, sirka: CGFloat) -> UIImage? {
        print("Metoda nastavObrazok bola vykonana")
        
        guard let obrazok = obrazok else {
            return nil
        }
        
        let pomer = sirka / obrazok.size.width
        let vyska = obrazok.size.height * pomer
        
        let velkost = CGSize(width: sirka, height: vyska)
        
        UIGraphicsBeginImageContext(velkost)
        obrazok.draw(in: CGRect(origin: .zero, size: velkost))
        let spravnyObrazok = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return spravnyObrazok
    }
}
