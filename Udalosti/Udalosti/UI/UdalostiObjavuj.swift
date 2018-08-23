//
//  UdalostiObjavuj.swift
//  Udalosti
//
//  Created by Bence Mate on 8/9/18.
//  Copyright © 2018 Bence Mate. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UdalostiObjavuj: UIViewController, UITableViewDataSource, UITableViewDelegate, KommunikaciaOdpoved, KommunikaciaData{
    
    private let delegate = UIApplication.shared.delegate as! AppDelegate
    private var udalostiUdaje : UdalostiUdaje!
    private var uvodnaObrazovkaUdaje: UvodnaObrazovkaUdaje!
    
    var pouzivatelskeUdaje: NSDictionary!
    var udalosti = [Udalost]()
    
    @IBOutlet weak var titul: UINavigationItem!
    @IBOutlet weak var zoznamUdalosti: UITableView!
    @IBOutlet weak var nacitavanie: UIActivityIndicatorView!
    @IBOutlet weak var ziadneUdalosti: UIImageView!
    
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
                ziadneUdalosti.isHidden = true
                for i in 0..<data!.count{
                    self.udalosti.append(Udalost(
                        idUdalost: (data![i] as AnyObject).value(forKey: "idUdalost") as? String,
                        obrazok: (data![i] as AnyObject).value(forKey: "obrazok") as? String,
                        nazov: (data![i] as AnyObject).value(forKey: "nazov") as? String,
                        den: (data![i] as AnyObject).value(forKey: "den") as? String,
                        mesiac: (data![i] as AnyObject).value(forKey: "mesiac") as? String,
                        cas: (data![i] as AnyObject).value(forKey: "cas") as? String,
                        miesto: (data![i] as AnyObject).value(forKey: "miesto") as? String
                    ))
                }
                self.zoznamUdalosti.reloadData()
            } else if(odpoved == Nastavenia.CHYBA){
                ziadneUdalosti.isHidden = false
            }
            break;
        default: break
        }
        self.zoznamUdalosti.reloadData()
        self.nacitavanie.isHidden = true
    }
    
    func statPrihlasenia(){
        print("Metoda statPrihlasenia bola vykonana")

        let miesto: NSDictionary = udalostiUdaje.miestoPrihlasenia()
        self.titul.title = miesto.value(forKey: "stat") as? String
        self.nacitajZoznamUdalosti(miesto: miesto)
    }
    
    func nacitajZoznamUdalosti(miesto: NSDictionary){
        print("Metoda nacitajZoznamUdalosti bola vykonana")
        
        self.nacitavanie.isHidden = false
        self.udalostiUdaje.zoznamUdalosti(
            email: pouzivatelskeUdaje.value(forKey: "email") as! String,
            stat: miesto.value(forKey: "stat") as! String,
            token: pouzivatelskeUdaje.value(forKey: "token") as! String)
    }
    
    func nastavMiestoUdalosti(miesto:String, vrat: Int) -> String{
        print("Metoda nastavMiestoUdalosti bola vykonana")

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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let riadokUdalosti = tableView.dequeueReusableCell(withIdentifier: "udalosti", for: indexPath) as! UdalostiTableViewCell
        
        let udalost: Udalost
        udalost = udalosti[indexPath.row]
        
        riadokUdalosti.datum.text = udalost.den
        riadokUdalosti.mesiac.text = udalost.mesiac
        riadokUdalosti.nazov.text = udalost.nazov
        riadokUdalosti.mesto.text = self.nastavMiestoUdalosti(miesto: udalost.miesto!, vrat: 0)
        riadokUdalosti.miesto.text = self.nastavMiestoUdalosti(miesto: udalost.miesto!, vrat: 1)
        riadokUdalosti.cas.text = udalost.cas
        
        Alamofire.request(delegate.udalostiAdresa+"udalosti/"+udalost.obrazok!).responseImage { response in
            debugPrint(response)
            
            if let obrazokUdalosti = response.result.value {
                riadokUdalosti.obrazok.image = Obrazok.nastavObrazok(obrazokUdalosti, sirka: riadokUdalosti.obrazok.frame.width)
            }else {
                riadokUdalosti.obrazok.image = UIImage(named: "chyba_obrazka")!
                riadokUdalosti.obrazok.contentMode = .scaleAspectFill;
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
