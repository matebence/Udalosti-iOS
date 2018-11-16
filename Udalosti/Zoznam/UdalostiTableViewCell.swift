//
//  UdalostiTableViewCell.swift
//  Udalosti
//
//  Created by Bence Mate on 8/10/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class UdalostiTableViewCell: UITableViewCell {

    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var obrazok: UIImageView!
    @IBOutlet weak var datum: UILabel!
    @IBOutlet weak var mesiac: UILabel!
    @IBOutlet weak var nazov: UILabel!
    @IBOutlet weak var mesto: UILabel!
    @IBOutlet weak var miesto: UILabel!
    @IBOutlet weak var cas: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        print("Metoda setSelected - UdalostiTableViewCell bola vykonana")

        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        print("Metoda prepareForReuse - UdalostiTableViewCell bola vykonana")

        self.obrazok.image = nil
        self.datum.text = nil
        self.mesiac.text = nil
        self.nazov.text = nil
        self.mesto.text = nil
        self.miesto.text = nil
        self.cas.text = nil
    }
}
