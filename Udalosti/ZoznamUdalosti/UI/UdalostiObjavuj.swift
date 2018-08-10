//
//  UdalostiObjavuj.swift
//  Udalosti
//
//  Created by Bence Mate on 8/9/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit

class UdalostiObjavuj: UIViewController, KommunikaciaOdpoved {

    var pouzivatelskeUdaje: NSDictionary!
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!

    @IBOutlet weak var titul: UINavigationItem!
    @IBAction func odhlasitSa(_ sender: UIBarButtonItem) {
        udalostiUdaje.odhlasenie(email: pouzivatelskeUdaje.value(forKey: "email") as! String)
    }

    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        switch od {
        case Nastavenia.AUTENTIFIKACIA_ODHLASENIE:
            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                print("Odhlasenie prebehlo uspesne")
                udalostiUdaje.automatickePrihlasenieVypnute(email: pouzivatelskeUdaje.value(forKey: "email") as! String)
                
                let udalosti = UIStoryboard(name: "Udalosti", bundle: nil)
                let autentifikaciaController = udalosti.instantiateViewController(withIdentifier: "Autentifikacia")
                self.present(autentifikaciaController, animated: true, completion: nil)
            }
            break;
        default: break
        }
    }
    
    func statPrihlasenia(){
        print("Metoda statPrihlasenia bola vykonana")

        let miesto: NSDictionary = udalostiUdaje.miestoPrihlasenia()
        self.titul.title = miesto.value(forKey: "stat") as? String
    }
    
    func inicializacia (){
        print("Metoda inicializacia-UdalostiObjavuj bola vykonana")

        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        self.pouzivatelskeUdaje = uvodnaObrazovkaUdaje.prihlasPouzivatela()
        self.statPrihlasenia()
    }
    
    override func viewDidLoad() {
        self.inicializacia()
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
