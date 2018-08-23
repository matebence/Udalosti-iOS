//
//  Udalosti.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import SwipeableTabBarController

class NavigaciaUdalosti: SwipeableTabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nastavGesta()
    }
    
    func nastavGesta(){
        selectedIndex = 0
        
        setSwipeAnimation(type: SwipeAnimationType.push)
        setTapAnimation(type: SwipeAnimationType.push)
        
        setDiagonalSwipe(enabled: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
