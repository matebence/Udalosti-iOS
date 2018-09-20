//
//  UvodnaObrazovkaImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol UvodnaObrazovkaImplementacia {
    func zistiCiPouzivatelExistuje() -> Bool
    func prihlasPouzivatela() -> NSDictionary
}
