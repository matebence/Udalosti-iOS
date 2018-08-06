//
//  KommunikaciaOdpoved.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
protocol KommunikaciaOdpoved {
    func odpovedServera(odpoved: String, od: String, udaje:NSDictionary?) -> Void
}
