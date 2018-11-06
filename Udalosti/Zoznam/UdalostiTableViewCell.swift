//
//  UdalostiTableViewCell.swift
//  Udalosti
//
//  Created by Bence Mate on 8/10/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class UdalostiTableViewCell: UITableViewCell {

    @IBOutlet weak var obrazok: UIImageView!
    @IBOutlet weak var datum: UILabel!
    @IBOutlet weak var mesiac: UILabel!
    @IBOutlet weak var nazov: UILabel!
    @IBOutlet weak var mesto: UILabel!
    @IBOutlet weak var miesto: UILabel!
    @IBOutlet weak var cas: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
