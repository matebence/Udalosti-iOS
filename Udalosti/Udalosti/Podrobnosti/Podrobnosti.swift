//
//  Podrobnosti.swift
//  Udalosti
//
//  Created by Bence Mate on 11/14/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Podrobnosti: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
	
