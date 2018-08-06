//
//  Registracia.swift
//  Udalosti
//
//  Created by Bence Mate on 8/5/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class Registracia: UIViewController, KommunikaciaOdpoved {
       
    @IBOutlet weak var vstupPouzivatelskeMena: UITextField!
    @IBOutlet weak var vstupEmailu: UITextField!
    @IBOutlet weak var vstupHesla: UITextField!
    @IBOutlet weak var vstupPotvrdenieHesla: UITextField!
    
    @IBAction func registrovatSa(_ sender: UIButton) {
        let autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        autentifikaciaUdaje.registracia(meno: vstupPouzivatelskeMena.text!, email: vstupEmailu.text!, heslo: vstupHesla.text!, potvrd: vstupPotvrdenieHesla.text!)
    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print(odpoved)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
