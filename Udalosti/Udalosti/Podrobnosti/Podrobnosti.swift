//
//  Podrobnosti.swift
//  Udalosti
//
//  Created by Bence Mate on 11/14/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import Alamofire

class Podrobnosti: UIViewController, KommunikaciaOdpoved, KommunikaciaData {

    private let delegate = UIApplication.shared.delegate as! AppDelegate
    var udalost:Udalost!

    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    
    @IBOutlet weak var tlacidlo: UIButton!
    @IBOutlet weak var obsahObrazka: UIImageView!
    @IBOutlet weak var nazovMiesto: UIStackView!
    @IBOutlet weak var oddelovac: UIView!
    @IBOutlet weak var zaujemcovia: UIStackView!
    @IBOutlet weak var vstupenka: UIStackView!
    @IBOutlet weak var cas: UIStackView!
    
    @IBOutlet weak var obrazokZvolenejUdalosti: UIImageView!
    @IBOutlet weak var denZvolenejUdalosti: UILabel!
    @IBOutlet weak var mesiacZvolenejUdalosti: UILabel!
    @IBOutlet weak var nazovZvolenejUdalosti: UILabel!
    @IBOutlet weak var miestoZvolenejUdalosti: UILabel!
    @IBOutlet weak var pocetZaujemcovZvolenejUdalosti: UILabel!
    @IBOutlet weak var vstupenkaZvolenejUdalosti: UILabel!
    @IBOutlet weak var casZvolenejUdalosti: UILabel!

    @IBAction func zaujem(_ sender: Any) {
        print("Metoda zaujem bola vykonana")

    }

    override func viewWillDisappear(_ animated: Bool) {
        print("Metoda viewWillDisappear - Podrobnosti bola vykonana")
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        print("Metoda viewDidLoad - Podrobnosti bola vykonana")
        
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        self.denZvolenejUdalosti.text = self.udalost.den
        self.mesiacZvolenejUdalosti.text = self.udalost.mesiac
        self.nazovZvolenejUdalosti.text = self.udalost.nazov
        self.miestoZvolenejUdalosti.text = self.udalost.mesto!+self.udalost.ulica!
        self.pocetZaujemcovZvolenejUdalosti.text = self.udalost.zaujemcovia
        self.vstupenkaZvolenejUdalosti.text = self.udalost.vstupenka!+"€"
        self.casZvolenejUdalosti.text = self.udalost.cas
        
        Alamofire.request(self.delegate.udalostiAdresa+self.udalost.obrazok!).responseImage { response in
            debugPrint(response)
            
            if let obrazokUdalosti = response.result.value {
                self.obrazokZvolenejUdalosti.image = Obrazok.nastavObrazok(obrazokUdalosti, sirka: self.obrazokZvolenejUdalosti.frame.width)
            }else {
                self.obrazokZvolenejUdalosti.image = UIImage(named: "chyba_obrazka")!
                self.obrazokZvolenejUdalosti.contentMode = .scaleAspectFill;
            }
        }
        
        nastavTlacidlo(zaujem: Int(self.udalost.zaujem!)!)
        
        self.tlacidlo.isHidden = false
        self.obsahObrazka.isHidden = false
        self.nazovMiesto.isHidden = false
        self.oddelovac.isHidden = false
        self.zaujemcovia.isHidden = false
        self.vstupenka.isHidden = false
        self.cas.isHidden = false
        
        nacitavanie.isHidden = true
    }
    
    func inicializacia (){
        print("Metoda inicializacia - Podrobnosti bola vykonana")
    }
    
    func nastavTlacidlo(zaujem: Int){
        print("Metoda nastavTlacidlo bola vykonana")
        
        if(zaujem == 1){
            self.tlacidlo.setTitle("Odstrániť zo záujmov", for: .normal)
            self.tlacidlo.backgroundColor = UIColor(red:0.67, green:0.15, blue:0.15, alpha:1.0)
        }else{
            self.tlacidlo.setTitle("Mám záujem", for: .normal)
            self.tlacidlo.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.65, alpha:1.0)
        }
    }
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        print("Metoda dataZoServera - Podrobnosti bola vykonana")

    }
    
    func odpovedServera(odpoved: String, od: String, udaje: NSDictionary?) {
        print("Metoda odpovedServera - Podrobnosti bola vykonana")

    }
}
