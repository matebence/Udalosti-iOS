//
//  AktualizatorObsahu.swift
//  Udalosti
//
//  Created by Bence Mate on 11/15/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import Foundation

class AktualizatorObsahu{
    
    private static var aktualizatorObsahu: AktualizatorObsahu!
    private var aktualizator: Aktualizator!
    
    init() {
        print("Metoda init bola vykonana")
        
    }
    
    static func zaujmy() -> AktualizatorObsahu{
        print("Metoda zaujmy bola vykonana")
        
        if(AktualizatorObsahu.aktualizatorObsahu == nil){
            AktualizatorObsahu.aktualizatorObsahu = AktualizatorObsahu()
        }
        
        return AktualizatorObsahu.aktualizatorObsahu
    }
    
    func nastav(aktualizator: Aktualizator) -> Void{
        print("Metoda nastav bola vykonana")
        
        self.aktualizator = aktualizator
    }
    
    func aktualizuj() -> Void{
        print("Metoda aktualizuj bola vykonana")
        
        self.aktualizator.aktualizujObsahZaujmov();
    }
    
    func hodnota() -> Void{
        print("Metoda hodnota bola vykonana")
        
        if(self.aktualizator != nil){
            aktualizuj()
        }
    }
}
