//
//  ZaujmyTableViewCell.swift
//  Udalosti
//
//  Created by Bence Mate on 11/15/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class ZaujmyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var den: UILabel!
    @IBOutlet weak var mesiac: UILabel!
    @IBOutlet weak var nazov: UILabel!
    @IBOutlet weak var mesto: UILabel!
    @IBOutlet weak var ulica: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        print("Metoda setSelected - ZaujmyTableViewCell bola vykonana")
        
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        print("Metoda prepareForReuse - ZaujmyTableViewCell bola vykonana")
        
        self.den = nil
        self.mesiac = nil
        self.nazov = nil
        self.mesto = nil
        self.ulica = nil
    }
}

