//
//  UvodnaObrazovka.swift
//  Udalosti
//
//  Created by Bence Mate on 8/8/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//
import UIKit

class UvodnaObrazovka: UIViewController, KommunikaciaOdpoved {

    var autentifikaciaUdaje : AutentifikaciaUdaje!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "automatickePrihlasenie" {
            let automatickePrihlasenie = segue.destination as! Autentifikacia
            automatickePrihlasenie.chyba = sender as? Bool
        }
    }
    
    override func viewDidLoad() {
        self.autentifikaciaUdaje = AutentifikaciaUdaje(kommunikaciaOdpoved: self)
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "automatickePrihlasenie", sender: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
