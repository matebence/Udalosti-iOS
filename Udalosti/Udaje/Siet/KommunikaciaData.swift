//
//  KommunikaciaData.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation
protocol KommunikaciaData {
    func dataZoServera(odpoved: String, od: String, data:NSArray?) -> Void
}
