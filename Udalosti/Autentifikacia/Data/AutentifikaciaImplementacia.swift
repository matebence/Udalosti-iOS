//
//  AutentifikaciaImplementacia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/6/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

protocol AutentifikaciaImplementacia {
    func registracia(meno: String, email: String, heslo:String,potvrd:String) -> Void
}
