//
//  Udalosti.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class Navigacia: SwipeableTabBarController{
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - NavigaciaUdalosti bola vykonana")

        super.viewDidLoad()
        nastavGesta()
    }
    
    func nastavGesta(){
        print("Metoda nastavGesta bola vykonana")

        selectedIndex = 0
        
        setSwipeAnimation(type: SwipeAnimationType.push)
        setTapAnimation(type: SwipeAnimationType.push)
        
        setDiagonalSwipe(enabled: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("Metoda preferredStatusBarStyle - NavigaciaUdalosti bola vykonana")

        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        print("Metoda didReceiveMemoryWarning - NavigaciaUdalosti bola vykonana")

        super.didReceiveMemoryWarning()
    }
}
