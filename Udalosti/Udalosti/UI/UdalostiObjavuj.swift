//
//  UdalostiObjavuj.swift
//  Udalosti
//
//  Created by Bence Mate on 8/9/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireImage

class UdalostiObjavuj: UIViewController, UITableViewDataSource, UITableViewDelegate, KommunikaciaOdpoved, KommunikaciaData{
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    var pouzivatelskeUdaje: NSDictionary!
    var udalosti = [Udalost]()
    
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!

    @IBOutlet weak var titul: UINavigationItem!
    @IBOutlet weak var zoznamUdalosti: UITableView!
    
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
    
    func dataZoServera(odpoved: String, od: String, data: NSArray?) {
        switch od {
        case Nastavenia.UDALOSTI:
            if(odpoved == Nastavenia.VSETKO_V_PORIADKU){
                for i in 0..<data!.count{
                    self.udalosti.append(Udalost(
                        idUdalost: (data![i] as AnyObject).value(forKey: "idUdalost") as? String,
                        obrazok: (data![i] as AnyObject).value(forKey: "obrazok") as? String,
                        nazov: (data![i] as AnyObject).value(forKey: "nazov") as? String,
                        datum: (data![i] as AnyObject).value(forKey: "datum") as? String,
                        cas: (data![i] as AnyObject).value(forKey: "cas") as? String,
                        miesto: (data![i] as AnyObject).value(forKey: "miesto") as? String
                    ))
                }
                self.zoznamUdalosti.reloadData()
            }
            break;
        default: break
        }
        self.zoznamUdalosti.reloadData()
    }
    
    func statPrihlasenia(){
        print("Metoda statPrihlasenia bola vykonana")

        let miesto: NSDictionary = udalostiUdaje.miestoPrihlasenia()
        self.titul.title = miesto.value(forKey: "stat") as? String
        self.nacitajZoznamUdalosti(miesto: miesto)
    }
    
    func nacitajZoznamUdalosti(miesto: NSDictionary){
        self.udalostiUdaje.zoznamUdalosti(
            email: pouzivatelskeUdaje.value(forKey: "email") as! String,
            stat: miesto.value(forKey: "stat") as! String,
            token: pouzivatelskeUdaje.value(forKey: "token") as! String)
    }
    
    func nastavMiestoUdalosti(miesto:String, vrat: Int) -> String{
        var mestoMiesto = miesto.components(separatedBy: ",")
        if mestoMiesto.count > 1 {
            return mestoMiesto[vrat]
        } else {
            if vrat == 0 {
                return miesto
            }else {
                return ""
            }
        }
    }
    
    func inicializacia (){
        print("Metoda inicializacia-UdalostiObjavuj bola vykonana")

        self.udalostiUdaje = UdalostiUdaje(kommunikaciaOdpoved: self, kommunikaciaData: self)
        self.uvodnaObrazovkaUdaje = UvodnaObrazovkaUdaje()
        self.pouzivatelskeUdaje = uvodnaObrazovkaUdaje.prihlasPouzivatela()
        self.statPrihlasenia()
    }
    
    override func viewDidLoad() {
        self.inicializacia()
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return udalosti.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let riadokUdalosti = tableView.dequeueReusableCell(withIdentifier: "udalost", for: indexPath) as! UdalostiTableViewCell
        
        let udalost: Udalost
        udalost = udalosti[indexPath.row]
        
        riadokUdalosti.datum.text = udalost.datum
        riadokUdalosti.mesiac.text = "August"
        riadokUdalosti.nazov.text = udalost.nazov
        riadokUdalosti.mesto.text = self.nastavMiestoUdalosti(miesto: udalost.miesto!, vrat: 0)
        riadokUdalosti.miesto.text = self.nastavMiestoUdalosti(miesto: udalost.miesto!, vrat: 1)
        riadokUdalosti.cas.text = udalost.cas

        Alamofire.request(delegate.udalostiAdresa+"udalosti/"+udalost.obrazok!).responseImage { response in
            debugPrint(response)
            
            if let obrazokUdalosti = response.result.value {
                riadokUdalosti.obrazok.image = obrazokUdalosti
            }
        }
        
        return riadokUdalosti
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
